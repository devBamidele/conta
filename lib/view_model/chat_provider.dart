import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/models/chat.dart';
import 'package:conta/utils/enums.dart';
import 'package:conta/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../models/Person.dart';
import '../models/chat_tile_data.dart';
import '../models/current_chat.dart';
import '../models/message.dart';
import '../utils/app_utils.dart';
import '../utils/services/file_picker_service.dart';
import '../utils/widget_functions.dart';

class ChatProvider extends ChangeNotifier {
  Map<String, Message> selectedMessages = {};
  List<Message> deletedMessages = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  void clearCache() {
    cacheReplyChat = false;
    cacheReplyMessage = null;
  }

  Future<void> copyMessageContent() async {
    final StringBuffer clipTextBuffer = StringBuffer();

    for (var message in selectedMessages.values) {
      clipTextBuffer.write('${message.content}\n');
    }

    final clipText = clipTextBuffer.toString().trim();

    await Clipboard.setData(ClipboardData(text: clipText));
  }

  // When the back button from the appbar is pressed
  void cancelReplyAndClearCache() {
    replyChat = false;
    replyMessage = null;

    // Cancel reply and clear cache
    clearCache();
    notifyListeners();
  }

  void clearReply() {
    replyChat = false;
    replyMessage = null;

    notifyListeners();
  }

  Stream<List<Message>> getChatMessagesStream({
    required String currentUserUid,
    required String otherUserUid,
    required int limit,
  }) {
    String chatId = generateChatId(currentUserUid, otherUserUid);
    CollectionReference<Map<String, dynamic>> messageRef =
        firestore.collection('chats').doc(chatId).collection('messages');

    // Use the limit method to fetch a specific number of messages
    Query<Map<String, dynamic>> query =
        messageRef.orderBy('timestamp', descending: true).limit(limit);

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  Stream<List<ChatTileData>> getChatTilesStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference<Map<String, dynamic>> tileRef =
        firestore.collection('users').doc(userId).collection('chat_tile_data');

    return tileRef
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ChatTileData.fromJson({...doc.data(), 'chatId': doc.id}))
            .toList());
  }

  getChatStream() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('chats');

    // Return the list of documents matching the query
    return collectionReference
        .where('participants', arrayContains: userId)
        .snapshots();
  }

  String generateChatId(String currentUserUid, String otherUserUid) {
    // Sort the userId in ascending order to generate a consistent chat id
    // regardless of the order in which the uids are passed
    List<String> userId = [currentUserUid, otherUserUid]..sort();
    return '${userId[0]}_${userId[1]}';
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

    currentChat = CurrentChat(
      chatId: chatId,
      username: username,
      uidUser1: uidUser1,
      uidUser2: uidUser2,
      profilePicUrl: profilePicUrl,
    );
  }

  Future<void> updateMessageSeen(String messageId) async {
    final batch = FirebaseFirestore.instance.batch();
    final chatId = currentChat!.chatId;

    final messageRef = firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    // Update the 'seen' field of the message document to true
    batch.update(messageRef, {'seen': true});

    // Decrement the unreadCount field in the chat document by 1
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    batch.update(chatRef, {'unreadCount': FieldValue.increment(-1)});

    // Commit the batch
    await batch.commit();
  }

  Future<void> deleteMessage() async {
    if (selectedMessages.isNotEmpty) {
      // Get the chat ID and message IDs of the selected messages
      final chatId = currentChat!.chatId;

      // Create a copy of the messageIds
      List<String> messageIds = List.from(selectedMessages.keys);

      // Add all the selected messages to the deleted messages list
      deletedMessages.addAll(selectedMessages.values);

      // Clear the selected messages and reset the UI state
      resetSelectedMessages();

      // Get the reference to the messages collection for the current chat
      CollectionReference<Map<String, dynamic>> messageRef =
          firestore.collection('chats').doc(chatId).collection('messages');

      // Create a batch, so we don't perform multiple operations
      WriteBatch batch = firestore.batch();

      // Add delete operations to the batch
      for (var id in messageIds) {
        batch.delete(messageRef.doc(id));
      }

      // Commit the batch operation
      await batch.commit();
    }
  }

  Future<void> deleteFilesFromStorage() async {
    final filePickerService = FilePickerService();
    final fileUrls = <String>[];

    try {
      // Extract media URLs from each message in deletedMessages
      for (final message in deletedMessages) {
        final media = message.media;
        if (media != null) {
          fileUrls.addAll(media);
        }
      }

      // Delete the files from storage
      await filePickerService.deleteFilesFromStorage(fileUrls);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> undoDelete() async {
    final chatId = currentChat!.chatId;

    final messageRef =
        firestore.collection('chats').doc(chatId).collection('messages');

    final batch = firestore.batch();

    final deletedMessagesCopy = List.from(deletedMessages);

    for (var deletedMessage in deletedMessagesCopy) {
      final messageId = deletedMessage.id;

      final messageDocRef = messageRef.doc(messageId);

      batch.set(messageDocRef, deletedMessage.toJson());
    }

    try {
      await batch.commit();
      deletedMessages.clear();
    } catch (error) {
      log('Error restoring deleted messages: $error');

      AppUtils.showToast('Error restoring deleted massages');
    }
  }

  Future<void> clearDeletedMessages() async {
    await deleteFilesFromStorage().then(
      (value) => deletedMessages.clear(),
    );
    notifyListeners();
  }

  Future<void> updateChatInfo(
    String newLastMessage,
    WriteBatch batch,
  ) async {
    final chatId = currentChat!.chatId!;
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final data = {
      'unreadCount': FieldValue.increment(1),
      'lastMessage': newLastMessage,
      'lastMessageTimestamp': Timestamp.now(),
    };
    // Update the fields in the document
    batch.update(chatRef, data);
  }

  /// Adds a new chat message to the 'messages' sub-collection of the specified chat document.
  Future<void> addNewMessageToChat(
    String content, {
    required MessageType type,
    List<String>? media,
    List<String>? uIds,
    bool updateInfo = true,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final secondUser = currentChat!.uidUser2;
    final chatId = currentChat!.chatId!;
    final batch = FirebaseFirestore.instance.batch();
    String messageId = '';

    if (media == null) {
      messageId = const Uuid().v4();
    } else {
      messageId = uIds![0];
    }

    final messagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    final lastMessage =
        content.isEmpty ? media!.length.formattedPhotos() : content;

    if (media != null && (2 <= media.length && media.length <= 3)) {
      for (int i = 0; i < media.length; i++) {
        final id = uIds![i];

        final text = i == media.length - 1 ? content : '';

        final imageMessage =
            createMediaMessage(id, currentUser, secondUser, text, media[i]);

        batch.set(messagesCollection.doc(id), imageMessage.toJson());
      }

      if (updateInfo) {
        updateChatInfo(lastMessage, batch);
      }
    } else {
      final reply = cacheReplyChat;
      final replyMessage = cacheReplyMessage?.content;
      final replyId = cacheReplyMessage?.senderId;

      final newMessage = createSingleMessage(messageId, currentUser, secondUser,
          content, type, media, reply, replyMessage, replyId);

      batch.set(messagesCollection.doc(messageId), newMessage.toJson());

      if (updateInfo) {
        updateChatInfo(lastMessage, batch);
      }
    }

    clearCache();
    await batch.commit();
  }

  /// Uploads a new chat message to Firestore, creating a new chat document if necessary.
  Future<void> uploadChat(
    String content, {
    MessageType type = MessageType.text,
    List<String>? media,
    List<String>? uIds,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final secondUser = currentChat!.uidUser2;
    final user2PicUrl = currentChat!.profilePicUrl;
    final chatId =
        currentChat?.chatId ?? generateChatId(currentUser, secondUser);

    final lastMessage =
        content.isEmpty ? media!.length.formattedPhotos() : content;

    final chatRef = firestore.collection('chats').doc(chatId);

    final chatSnapshot = await chatRef.get();
    final shouldCreateNewChat = !chatSnapshot.exists;

    if (shouldCreateNewChat) {
      final newChat = Chat(
        unreadCount: type == MessageType.text ? 1 : uIds!.length,
        participants: [currentUser, secondUser],
        lastMessage: lastMessage,
        lastMessageTimestamp: Timestamp.now(),
        lastMessageSenderId: currentUser,
        user1PicUrl: null,
        user2PicUrl: user2PicUrl,
      );

      await chatRef.set(newChat.toJson());
    }

    clearReply();

    await addNewMessageToChat(
      content,
      type: type,
      media: media,
      uIds: uIds,
      updateInfo: chatSnapshot.exists,
    );
  }

  Stream<Person> getOnlineStatusStream() async* {
    final userDocRef = firestore.doc('users/${currentChat!.uidUser2}');

    await for (DocumentSnapshot<Map<String, dynamic>> snapshot
        in userDocRef.snapshots()) {
      yield Person.fromJson(snapshot.data()!);
    }
  }
}
