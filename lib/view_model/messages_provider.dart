import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/models/chat.dart';
import 'package:conta/utils/enums.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:uuid/uuid.dart';

import '../models/Person.dart';
import '../models/current_chat.dart';
import '../models/message.dart';
import '../models/response.dart';
import '../utils/app_utils.dart';
import '../utils/services/file_picker_service.dart';
import '../utils/widget_functions.dart';

class MessagesProvider extends ChangeNotifier {
  Map<String, Message> selectedMessages = {};
  List<Message> deletedMessages = [];
  static String? oppUserId;

  Person? personData;

  static bool? same(Response response) {
    return oppUserId == response.uidUser2;
  }

  void clearIdData() {
    oppUserId = null;

    notifyListeners();
  }

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

  // Todo: Need to work on this
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

  Future<void> downloadImages({required List<String> imageUrls}) async {
    final futures = imageUrls.map((image) => _downloadImage(image)).toList();

    try {
      await Future.wait(futures);
    } catch (error) {
      log('Error occurred during image download: $error');
    }
  }

  Future<void> _downloadImage(String imageUrl) async {
    try {
      var imageId = await ImageDownloader.downloadImage(
        imageUrl,
        destination: AndroidDestinationType.directoryPictures,
      );

      if (imageId == null) {
        AppUtils.showToast(' Cannot Access Storage, permission denied');
        return;
      }

      var path = await ImageDownloader.findPath(imageId);

      AppUtils.showSnackbar('Downloaded image from $imageUrl');

      log('Downloaded image from $imageUrl. Image ID: $imageId, Path: $path');
    } on PlatformException catch (error) {
      log('A platform error occurred $error');
    } catch (error) {
      log('Error occurred during image download for $imageUrl: $error');
    }
  }

  Stream<List<Message>> getChatMessagesStream({
    required String currentUserUid,
    required String otherUserUid,
    required int limit,
  }) {
    String chatId = generateChatId(currentUserUid, otherUserUid);

    CollectionReference<Map<String, dynamic>> messageRef = FirebaseFirestore
        .instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    // Use the limit method to fetch a specific number of messages
    Query<Map<String, dynamic>> query =
        messageRef.orderBy('timestamp', descending: true).limit(limit);

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
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

    oppUserId = uidUser2;

    notifyListeners();
  }

  void updateUserData(UserProvider userData) {
    personData = userData.userData;
  }

  Future<void> updateMessageSeen(String messageId) async {
    final firestore = FirebaseFirestore.instance;

    final batch = firestore.batch();
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

    final data = {
      'unreadCount': FieldValue.increment(-1),
      'lastMessageStatus': 'seen',
    };

    batch.update(chatRef, data);

    // Commit the batch
    await batch.commit();
  }

  Future<void> deleteMessage() async {
    final firestore = FirebaseFirestore.instance;

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
    final firestore = FirebaseFirestore.instance;

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
      AppUtils.showToast('Error restoring deleted massages');
    }
  }

  Future<void> clearDeletedMessages() async {
    checkAndDeleteEmptyChat();

    await deleteFilesFromStorage().then(
      (value) => deletedMessages.clear(),
    );
    notifyListeners();
  }

  Future<void> checkAndDeleteEmptyChat() async {
    final firestore = FirebaseFirestore.instance;

    final chatId = currentChat!.chatId;

    final messageRef =
        firestore.collection('chats').doc(chatId).collection('messages');

    final messagesQuery = await messageRef.limit(1).get();

    if (messagesQuery.size == 0) {
      // The 'messages' collection is empty, so delete the chat document
      await firestore.collection('chats').doc(chatId).delete();
    } else {
      await updateUnreadOnDelete();
    }
  }

  Future<void> updateUnreadOnDelete() async {
    final deletedMessagesCopy = List<Message>.from(deletedMessages);

    final chatId = currentChat!.chatId;
    final batch = FirebaseFirestore.instance.batch();
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    for (final message in deletedMessagesCopy) {
      if (!message.seen) {
        batch.update(chatRef, {'unreadCount': FieldValue.increment(-1)});
      }
    }

    await batch.commit();
  }

  Future<void> updateLastMessageId(String id, WriteBatch batch) async {
    final chatId = currentChat!.chatId!;
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final data = {
      'lastMessageId': id,
    };
    // Update the fields in the document
    batch.update(chatRef, data);
  }

  Future<void> updateChatInfo(String newLastMessage, WriteBatch batch) async {
    final chatId = currentChat!.chatId!;
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final data = {
      'unreadCount': FieldValue.increment(1),
      'lastMessage': newLastMessage,
      'lastMessageTimestamp': Timestamp.now(),
      'lastSenderUserId': currentChat!.uidUser1,
      'lastMessageStatus': MessageStatus.undelivered.name,
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

      updateLastMessageId(uIds!.last, batch);

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

      updateLastMessageId(messageId, batch);

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
    final user2name = currentChat!.username;

    final firestore = FirebaseFirestore.instance;

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
        lastSenderUserId: currentUser,
        userNames: [personData?.username ?? 'noName', user2name],
        profilePicUrls: [personData?.profilePicUrl, user2PicUrl],
        lastMessageId: '',
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
    final userDocRef =
        FirebaseFirestore.instance.doc('users/${currentChat!.uidUser2}');

    await for (DocumentSnapshot<Map<String, dynamic>> snapshot
        in userDocRef.snapshots()) {
      yield Person.fromJson(snapshot.data()!);
    }
  }
}
