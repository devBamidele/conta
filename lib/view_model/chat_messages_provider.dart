import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/models/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/Person.dart';
import '../models/chat_tile_data.dart';
import '../models/current_chat.dart';
import '../models/message.dart';
import '../models/search_user.dart';

typedef ResetOverlayColorCallback = void Function();

class ChatMessagesProvider extends ChangeNotifier {
  Map<String, Message> selectedMessages = {};
  ResetOverlayColorCallback? _resetOverlayColorCallback;

  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Declare a variable to store the subscription
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;

  void setResetOverlayColorCallback(ResetOverlayColorCallback callback) {
    _resetOverlayColorCallback = callback;
  }

  //late final MessagingService _messagingService = MessagingService();

  // Check if any message is currently long pressed
  bool isMessageLongPressed = false;

  void updateMLPValue() {
    if (selectedMessages.isEmpty) {
      isMessageLongPressed = false;
    } else {
      isMessageLongPressed = true;
    }
    notifyListeners();
  }

  /// Holds the profile information of the current selected chat
  CurrentChat? currentChat;

  bool replyChat = false;
  bool cacheReplyChat = false;

  Message? replyMessage;
  Message? cacheReplyMessage;

  void updateReplyBySwipe(Message message) {
    replyChat = true;
    replyMessage = message;

    cacheReplyChat = replyChat;
    cacheReplyMessage = replyMessage;

    notifyListeners();
  }

  void addToSelectedMessages(Message message) {
    selectedMessages[message.id] = message;
  }

  void removeFromSelectedMessages(Message message) {
    selectedMessages.remove(message.id);
  }

  void resetSelectedMessages() {
    for (var message in selectedMessages.values) {
      message.updateSelected(false);
    }

    if (_resetOverlayColorCallback != null) {
      _resetOverlayColorCallback!();
    }

    selectedMessages.clear();
    isMessageLongPressed = false;
    notifyListeners();
  }

  void updateReplyByAppBar() {
    if (selectedMessages.isNotEmpty) {
      updateReplyBySwipe(selectedMessages.values.first);
    }
  }

  void onLongTapMessage(Message message) {
    if (selectedMessages.containsKey(message.id)) {
      // Message is already selected, so unselect it
      selectedMessages.remove(message.id);
      message.updateSelected(false);
    } else {
      // Message is not selected yet, so select it
      message.updateSelected(true);
      selectedMessages[message.id] = message;
    }
    notifyListeners();
  }

  void removeCache() {
    cacheReplyChat = false;
    cacheReplyMessage = null;
  }

  void cancelReply() {
    replyChat = false;
    replyMessage = null;

    // Cancel reply and clear cache
    removeCache();
    notifyListeners();
  }

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

  Future<void> deleteMessage() async {
    // Get the chat ID and message IDs of the selected messages
    final chatId = currentChat!.chatId;
    final messageIds = selectedMessages.keys;

    // Get the reference to the messages collection for the current chat
    CollectionReference<Map<String, dynamic>> messageRef =
        firestore.collection('chats').doc(chatId).collection('messages');

    // Delete each selected message from Firestore
    for (var id in messageIds) {
      await messageRef.doc(id).delete();
    }

    // Clear the selected messages and reset the UI state
    resetSelectedMessages();
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

  /// This function transfers the critical values useful
  /// for displaying information on the chat screen page
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

    String? senderName = replyMessage?.senderId == currentUser?.uid
        ? 'You'
        : currentChat?.username;

    // Create a new Message object with the specified properties
    Message newMessage = Message(
      id: messageId,
      senderId: currentUser!.uid,
      recipientId: currentChat!.uidUser2,
      content: content,
      timestamp: Timestamp.now(),
      reply: cacheReplyChat,
      replyMessage: cacheReplyMessage?.content,
      sender: senderName,
    );

    // Clear the cache
    removeCache();

    // Add the new message to the 'messages' sub-collection of the specified chat
    // document in Firestore
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .set(newMessage.toJson());

    /*
     _messagingService.sendNotification(
      recipientIds: [currentChat!.uidUser2],
      message: content,
      senderName: currentUser!.displayName!,
    );
     */
  }

  // Todo : Look at the efficiency of this function
  Future<void> resetUnread(String chatId) async {
    final batch = firestore.batch();

    final chatTileDataRef = firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('chat_tile_data')
        .doc(chatId);

    final chatTileDataSnapshot = await chatTileDataRef.get();
    final chatTileData = chatTileDataSnapshot.data() as Map<String, dynamic>;
    final lastMessageSenderId = chatTileData['lastMessageSenderId'] as String?;

    if (lastMessageSenderId != currentUser!.uid) {
      batch.update(chatTileDataRef, {'recipientUnreadMessages': 0});
    }

    final chatRef = firestore.collection('chats').doc(chatId);
    final chatSnapshot = await chatRef.get();
    final chatData = chatSnapshot.data() as Map<String, dynamic>;

    final user1Id = chatData['user1Id'] as String?;
    final user2Id = chatData['user2Id'] as String?;

    if (currentUser!.uid == user1Id) {
      batch.update(chatRef, {'user1Unread': 0});
    } else if (currentUser!.uid == user2Id) {
      batch.update(chatRef, {'user2Unread': 0});
    }

    await batch.commit();
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
        user1Unread: 0,
        user2Unread: 0,
        user1Id: currentUser!.uid,
        user2Id: currentChat!.uidUser2,
      );

      await firestore.collection('chats').doc(chatId).set(newChat.toJson());
    }

    // Increment the unread message count
    // await updateUnreadCount(chatId, currentUser!.uid);

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

/*


 loading(String email) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int timer = 50; // Set the timer duration here
        Duration timerDuration = Duration(seconds: timer);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Verify your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryShadeColor,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountdownTimer(
                    durationInSeconds: timer,
                    onTimerTick: (duration) {
                      setState(() {
                        timerDuration = duration;
                      });
                    },
                  ),
                  addHeight(32),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [shadow],
                    ),
                    child: ElevatedButton(
                      style: elevatedButton,
                      onPressed: () {},
                      child: const Text(
                        'Proceed to Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            );
          },
        );
      },
    );
  }
 */
