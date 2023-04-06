import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conta/models/chat.dart';
import 'package:uuid/uuid.dart';

import '../models/Person.dart';
import '../models/chat_tile_data.dart';
import '../models/current_chat.dart';
import '../models/message.dart';
import '../models/search_user.dart';

class ChatMessagesProvider extends ChangeNotifier {
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Declare a variable to store the subscription
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;

  //late final MessagingService _messagingService = MessagingService();

  /// Holds the profile information of the current selected chat
  CurrentChat? currentChat;

  Stream<List<Message>> getChatMessagesStream({
    required String currentUserUid,
    required String otherUserUid,
  }) {
    String chatId = generateChatId(currentUserUid, otherUserUid);
    CollectionReference<Map<String, dynamic>> messageRef =
        firestore.collection('chats').doc(chatId).collection('messages');

    return messageRef.orderBy('timestamp', descending: false).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  Stream<List<ChatTileData>> getChatTilesStream() {
    final userId = currentUser!.uid;
    final CollectionReference<Map<String, dynamic>> tileRef =
        firestore.collection('users').doc(userId).collection('chat_tile_data');

    return tileRef
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatTileData.fromJson({
                    ...doc.data(),
                    'chatId': doc.id, // add document ID to the data map
                  }))
              .toList(),
        );
  }

  /// Generate unique chat id's for each Dm
  String generateChatId(String currentUserUid, String otherUserUid) {
    // Sort the userId in ascending order to generate a consistent chat id
    // regardless of the order in which the uids are passed
    List<String> userId = [currentUserUid, otherUserUid]..sort();
    return '${userId[0]}_${userId[1]}';
  }

  Stream<List<Person>> getSuggestionsStream(String filter) {
    return FirebaseFirestore.instance
        .collection('users')
        .limit(10)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Person.fromJson(doc.data()))
          .where((person) =>
              person.username.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    });
  }

  void addToRecentSearch({required Person person}) async {
    final userQuery = await FirebaseFirestore.instance
        .collection('recent_searches')
        .where('username', isEqualTo: person.username)
        .where('uidUser', isEqualTo: currentUser!.uid)
        .get();

    if (userQuery.docs.isEmpty) {
      // If the user doesn't exist, add them as a new user
      final search = SearchUser(
        timestamp: Timestamp.now(),
        name: person.name,
        uidUser: currentUser!.uid,
        username: person.username,
        uidSearch: person.id,
        profilePicUrl: person.profilePicUrl,
      ).toMap();
      await FirebaseFirestore.instance
          .collection('recent_searches')
          .add(search);
    } else {
      // If the user exists, update their timestamp
      final userDoc = userQuery.docs.first;
      await userDoc.reference.update({'timestamp': Timestamp.now()});
    }
  }

  Future<void> clearRecentSearch() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('recent_searches')
        .where('uidUser', isEqualTo: currentUser!.uid)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  void deleteFromRecentSearch({required String username}) async {
    final uid = currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('recent_searches')
        .where('username', isEqualTo: username)
        .where('uidUser', isEqualTo: uid)
        .get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }

  Stream<List<SearchUser>> getRecentSearches() {
    return FirebaseFirestore.instance
        .collection('recent_searches')
        .where('uidUser', isEqualTo: currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => SearchUser.fromMap(doc.data()))
            .toList());
  }

  void setCurrentChat({
    required String username,
    required String uidUser1,
    required String uidUser2,
    String? profilePicUrl,
  }) {
    final chatId = generateChatId(uidUser1, uidUser2);

    final chat = CurrentChat(
      chatId: chatId,
      username: username,
      uidUser1: uidUser1,
      uidUser2: uidUser2,
      profilePicUrl: profilePicUrl,
    );
    currentChat = chat;
  }

  Future<void> updateMessageSeen(String messageId) async {
    final id = currentChat!.chatId;
    await firestore
        .collection('chats')
        .doc(id)
        .collection('messages')
        .doc(messageId)
        .update({'seen': true});
  }

  /// Uploads a new chat message to Firestore, adding it to the 'messages'
  /// sub-collection of the specified chat document.
  ///
  /// The [content] parameter is the text of the message to add.
  Future<void> addNewMessageToChat(String chatId, String content) async {
    // Generate a unique ID for the new message
    String messageId = const Uuid().v4();

    // Create a new Message object with the specified properties
    Message newMessage = Message(
      id: messageId,
      senderId: currentUser!.uid,
      recipientId: currentChat!.uidUser2,
      content: content,
      timestamp: Timestamp.now(),
    );

    // Add the new message to the 'messages' sub-collection of the specified chat
    // document in Firestore
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(newMessage.id)
        .set(newMessage.toJson());

    /*
     _messagingService.sendNotification(
      recipientIds: [currentChat!.uidUser2],
      message: content,
      senderName: currentUser!.displayName!,
    );
     */
  }

  /// Uploads a new chat message to Firestore, creating a new chat document if
  /// necessary.
  ///
  /// The [content] parameter is the text of the message to add.
  Future<void> uploadChat(String content) async {
    // Generate a unique ID for the new chat document
    String chatId = generateChatId(currentUser!.uid, currentChat!.uidUser2);

    // Check if the chat already exists in Firestore
    DocumentSnapshot chatSnapshot =
        await firestore.collection('chats').doc(chatId).get();

    if (!chatSnapshot.exists) {
      // Chat doesn't exist, create new chat document
      Chat newChat = Chat(
        id: chatId,
        user1Id: currentUser!.uid,
        user2Id: currentChat!.uidUser2,
      );

      final batch = FirebaseFirestore.instance.batch();

      batch.set(
        firestore.collection('users').doc(currentUser!.uid),
        {
          'chats': FieldValue.arrayUnion([chatId])
        },
        SetOptions(merge: true),
      );

      batch.set(
        firestore.collection('users').doc(currentChat!.uidUser2),
        {
          'chats': FieldValue.arrayUnion([chatId])
        },
        SetOptions(merge: true),
      );

      await batch.commit();

      //...
      await firestore.collection('chats').doc(chatId).set(newChat.toJson());
    }

    // Add the new message to the 'messages' sub-collection of the chat document
    // in Firestore
    await addNewMessageToChat(chatId, content);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOnlineStatusStream() {
    final DocumentReference userDocRef =
        firestore.doc('users/${currentChat!.uidUser2}');

    // Add a listener to the user's online status document
    final StreamController<DocumentSnapshot<Map<String, dynamic>>> controller =
        StreamController();

    subscription = userDocRef
        .snapshots()
        .map((snapshot) => snapshot as DocumentSnapshot<Map<String, dynamic>>)
        .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      controller.add(snapshot);
    });

    // When the stream is cancelled, remove the listener
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }

  // Call this function when the user exits the chat screen
  void removeOnlineStatusListener() {
    subscription.cancel();
  }
}
