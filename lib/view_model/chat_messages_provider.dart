import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conta/models/chat.dart';
import 'package:uuid/uuid.dart';

import '../models/Person.dart';
import '../models/current_chat.dart';
import '../models/message.dart';
import '../models/search_user.dart';
import '../utils/services/messaging_service.dart';

class ChatMessagesProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final MessagingService _messagingService = MessagingService();

  Stream<List<Message>> getChatMessagesStream({
    required String currentUserUid,
    required String otherUserUid,
  }) {
    CollectionReference chatRef =
        FirebaseFirestore.instance.collection('chats');
    String chatId = generateChatId(currentUserUid, otherUserUid);

    return chatRef.doc(chatId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return [];
      }

      List<dynamic> messages = snapshot.get('messages');

      return messages
          .map(
              (message) => Message.fromJson(Map<String, dynamic>.from(message)))
          .toList();
    });
  }

  /// Generate unique chat id's for each Dm
  String generateChatId(String currentUserUid, String otherUserUid) {
    // Sort the userId in ascending order to generate a consistent chat id regardless of the order in which the uids are passed
    List<String> userId = [currentUserUid, otherUserUid]..sort();
    return '${userId[0]}_${userId[1]}';
  }

  /// Get a list of all the users names
  Stream<List<String>> getAllUserNames() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => doc['name'] as String).toList());
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
        tokenId: person.tokenId,
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

  setCurrentChat({
    required String username,
    required String uidUser1,
    required String uidUser2,
    String? profilePicUrl,
    String? tokenId,
  }) {
    final chat = CurrentChat(
      username: username,
      uidUser1: uidUser1,
      uidUser2: uidUser2,
      profilePicUrl: profilePicUrl,
      tokenId: tokenId,
    );
    currentChat = chat;
  }

  Future<void> addNewMessageToChat(Chat chat, String content) async {
    String messageId = const Uuid().v4();
    Message newMessage = Message(
      id: messageId,
      senderId: currentUser!.uid,
      recipientId: currentChat!.uidUser2,
      content: content,
      timestamp: Timestamp.now(),
    );
    chat.messages.add(newMessage);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.id)
        .update({'messages': chat.messages.map((m) => m.toJson()).toList()});
  }

  Future<void> uploadChat(String content) async {
    String chatId = generateChatId(currentUser!.uid, currentChat!.uidUser2);

    // Check if chat already exists in Firestore
    DocumentSnapshot chatSnapshot =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

    if (!chatSnapshot.exists) {
      // Chat doesn't exist, create new chat document
      Chat newChat = Chat(
        id: chatId,
        user1Id: currentUser!.uid,
        user2Id: currentChat!.uidUser2,
        messages: [],
      );
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .set(newChat.toJson());

      await addNewMessageToChat(newChat, content);
    } else {
      Chat chat = Chat.fromJson(chatSnapshot.data() as Map<String, dynamic>);
      await addNewMessageToChat(chat, content);
    }
  }

  /// Holds the profile information of the current selected chat
  CurrentChat? currentChat;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOnlineStatusStream() =>
      firestore.doc('users/${currentChat!.uidUser2}').snapshots();
}
