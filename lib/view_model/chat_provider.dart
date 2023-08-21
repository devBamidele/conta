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
import 'package:uuid/uuid.dart';

import '../models/Person.dart';
import '../models/current_chat.dart';
import '../models/message.dart';
import '../models/response.dart';
import '../utils/app_utils.dart';
import '../utils/services/contacts_service.dart';
import '../utils/services/file_picker_service.dart';
import '../utils/widget_functions.dart';

class ChatProvider extends ChangeNotifier {
  Map<String, Message> selectedMessages = {};
  List<Message> deletedMessages = [];
  static String? oppUserId;

  Person? personData;

  String? _filter;

  String? get filter => _filter;

  set filter(String? value) {
    _filter = value;

    notifyListeners();
  }

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

  List<String?> phoneNumbers = [];

  Future<void> getContacts() async {
    ContactService contacts = ContactService();

    await contacts.fetchContacts();

    phoneNumbers = contacts.userContacts
        .where(
            (contact) => contact.phones != null && contact.phones!.isNotEmpty)
        .map((contact) {
      final phoneNumber = contact.phones!.first.value;
      return phoneNumber.formatPhoneNumber();
    }).toList();
  }

  Future<List<Person>> findAppUsersFromContact() async {
    await getContacts();

    final CollectionReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users');

    // Split phoneNumbers into chunks of 30
    const chunkSize = 30;

    final totalChunks = (phoneNumbers.length / chunkSize).ceil();

    // Create a list to store the resulting List of matching users
    final resultList = <Person>[];

    for (var i = 0; i < totalChunks; i++) {
      final start = i * chunkSize;
      final end = (i + 1) * chunkSize;
      final chunkNumbers = phoneNumbers.sublist(
          start, end < phoneNumbers.length ? end : phoneNumbers.length);

      // Fetch data from Firestore for each chunk
      final querySnapshot =
          await userRef.where('phone', whereIn: chunkNumbers).get();

      // Process the documents and add to the resultList
      final chunkPersons =
          querySnapshot.docs.map((doc) => Person.fromJson(doc.data()));
      resultList.addAll(chunkPersons);
    }

    // Return the aggregated resultList as a Stream
    return resultList;
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

  Stream<List<Chat>> getAllChatsStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference<Map<String, dynamic>> chatRef =
        FirebaseFirestore.instance.collection('chats');

    return chatRef
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((chat) => isChatMatchSearchQuery(chat.data(), userId))
            .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  bool isChatMatchSearchQuery(
    Map<String, dynamic> chatData,
    String uid,
  ) {
    if (filter == null || filter!.isEmpty) {
      return true;
    }
    final participants = chatData['participants'] as List<dynamic>;
    final currentUserPosition = participants.indexOf(uid);

    if (currentUserPosition != -1) {
      final oppositePosition = (currentUserPosition + 1) % 2;
      final oppositeUsername = chatData['names'][oppositePosition] as String;

      return oppositeUsername.toLowerCase().contains(filter!.toLowerCase());
    }

    return false;
  }

  Stream<List<Chat>> getUnreadChatsStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference<Map<String, dynamic>> chatRef =
        FirebaseFirestore.instance.collection('chats');

    return chatRef
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) =>
                doc['lastSenderUserId'] != userId && doc['unreadCount'] > 0)
            .where((chat) => isChatMatchSearchQuery(chat.data(), userId))
            .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Stream<List<Chat>> getMutedChatsStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference<Map<String, dynamic>> chatRef =
        FirebaseFirestore.instance.collection('chats');

    return chatRef
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) {
              // Get participants array from the document
              final participants = doc['participants'] as List<dynamic>;

              // Determine the indices of the current user and the opposite user
              final currentUserIndex = participants.indexOf(userId);
              final oppositeUserIndex = currentUserIndex == 0 ? 1 : 0;

              // Check if the opposite user is muted, default to false if not found
              return doc['userMuted'][oppositeUserIndex] ?? false;
            })
            .where((chat) => isChatMatchSearchQuery(chat.data(), userId))
            .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
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

  Future<void> toggleMutedStatus({
    required String chatId,
    required int index,
    required bool newValue,
  }) async {
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final chatSnapshot = await chatRef.get();

    if (chatSnapshot.exists) {
      List<bool> userMuted = List<bool>.from(chatSnapshot.data()!['userMuted']);

      userMuted[index] = newValue;

      await chatRef.update({'userMuted': userMuted});
      log('User muted status updated successfully.');
    } else {
      log('Chat not found.');
    }
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
    updateUnreadOnDelete();

    await deleteFilesFromStorage().then(
      (value) => deletedMessages.clear(),
    );
    notifyListeners();
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

  Future<void> updateLastMessageId(
    String id,
    WriteBatch batch,
  ) async {
    final chatId = currentChat!.chatId!;
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final data = {
      'lastMessageId': id,
    };
    // Update the fields in the document
    batch.update(chatRef, data);
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
