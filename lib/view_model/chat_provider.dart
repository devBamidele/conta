import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/models/chat.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/utils/services/algolia_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/Person.dart';
import '../utils/services/contacts_service.dart';

class ChatProvider extends ChangeNotifier {
  List<String?> phoneNumbers = [];

  bool emptyContacts = false;

  void updateEmptyContacts(bool isEmpty) {
    emptyContacts = isEmpty;

    notifyListeners();
  }

  bool emptySearch = false;

  void updateEmptySearch(bool isEmpty) {
    emptySearch = isEmpty;

    notifyListeners();
  }

  String? _chatFilter;

  String? get chatFilter {
    return _chatFilter;
  }

  set chatFilter(String? value) {
    _chatFilter = value;

    notifyListeners();
  }

  String? _contactFilter;

  String? get contactFilter {
    return _contactFilter;
  }

  set contactFilter(String? value) {
    _contactFilter = value;

    notifyListeners();
  }

  String? _blockedFilter;

  String? get blockedFilter => _blockedFilter;

  set blockedFilter(String? value) {
    _blockedFilter = value;

    notifyListeners();
  }

  clearBlockedFilter() {
    _blockedFilter = '';

    notifyListeners();
  }

  clearContactsFilter() {
    _contactFilter = '';

    notifyListeners();
  }

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

  Stream<List<Person>> findAppUsersFromContact() async* {
    await getContacts();

    final CollectionReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users');

    // Split phoneNumbers into chunks of 30
    const chunkSize = 30;

    final totalChunks = (phoneNumbers.length / chunkSize).ceil();

    // Iterate through the chunks and yield the filtered results
    for (var i = 0; i < totalChunks; i++) {
      final start = i * chunkSize;
      final end = (i + 1) * chunkSize;

      final chunkNumbers = phoneNumbers.sublist(
        start,
        end < phoneNumbers.length ? end : phoneNumbers.length,
      );

      // Fetch data from Firestore for each chunk
      final querySnapshot =
          await userRef.where('phone', whereIn: chunkNumbers).get();

      // Apply local filtering and yields filtered results
      final personList = querySnapshot.docs
          .map((doc) => Person.fromJson(doc.data()))
          .where((person) => filterContactSearchQuery(person))
          .toList();

      updateEmptyContacts(personList.isEmpty);

      yield personList;
    }
  }

  Stream<List<Person>> findAppUsersNotInContacts() async* {
    const algolia = AlgoliaService.algolia;

    final query =
        algolia.instance.index('dev_conta').query(contactFilter ?? '');

    final snapshot = await query.getObjects();

    yield snapshot.hits
        .map((doc) => Person.fromJson(doc.data))
        .where((person) => !phoneNumbers.contains(person.phone))
        .toList();

    // updateEmptySearch(uniquePersons.isEmpty);

    // yield uniquePersons;
  }

  bool filterContactSearchQuery(
    Person person,
  ) {
    if (contactFilter == null || contactFilter!.isEmpty) {
      return true;
    }
    final username = person.username.toLowerCase();
    return username.contains(contactFilter!.toLowerCase());
  }

  Stream<List<Chat>> getBlockedChatStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference<Map<String, dynamic>> chatRef =
        FirebaseFirestore.instance.collection('chats');

    return chatRef
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where(
                (chat) => filterBlocked(chat.data(), userId, onlyBlocked: true))
            .where((chat) => filterBlockedSearchQuery(chat.data(), userId))
            .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
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
            .where((chat) => filterDeleted(chat.data(), userId))
            .where((chat) => filterBlocked(chat.data(), userId))
            .where((chat) => filterChatSearchQuery(chat.data(), userId))
            .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
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
            .where((chat) => filterDeleted(chat.data(), userId))
            .where((chat) => filterBlocked(chat.data(), userId))
            .where((chat) => filterUnread(chat.data(), userId))
            .where((chat) => filterChatSearchQuery(chat.data(), userId))
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
            .where((chat) => filterDeleted(chat.data(), userId))
            .where((chat) => filterMuted(chat.data(), userId))
            .where((chat) => filterBlocked(chat.data(), userId))
            .where((chat) => filterChatSearchQuery(chat.data(), userId))
            .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  bool filterUnread(
    Map<String, dynamic> chatData,
    String uid,
  ) {
    return chatData['lastSenderUserId'] != uid && chatData['unreadCount'] > 0;
  }

  bool filterMuted(
    Map<String, dynamic> chatData,
    String uid,
  ) {
    final participants = chatData['participants'] as List<dynamic>;

    // Determine the indices of the current user and the opposite user
    final currentUserIndex = participants.indexOf(uid);
    final oppositeUserIndex = currentUserIndex == 0 ? 1 : 0;

    // Check if the opposite user is muted, default to false if not found
    return chatData['userMuted'][oppositeUserIndex] ?? false;
  }

  bool filterDeleted(Map<String, dynamic> chatData, String uid) {
    final participants = chatData['participants'] as List<dynamic>?;

    final deletedAccount = chatData['deletedAccount'] as List<dynamic>?;

    if (participants == null || deletedAccount == null) {
      return true; // Handle missing data gracefully
    }

    int currentUserIndex = participants.indexOf(uid);
    final data = deletedAccount[currentUserIndex] as bool?;

    return data != null ? !data : false;
  }

  bool filterBlocked(
    Map<String, dynamic> chatData,
    String uid, {
    bool onlyBlocked = false,
  }) {
    final participants = chatData['participants'] as List<dynamic>;
    final currentUserPosition = participants.indexOf(uid);

    if (currentUserPosition != -1) {
      final oppositePosition = (currentUserPosition + 1) % 2;
      final oppUserBlocked = chatData['userBlocked'][oppositePosition] as bool;

      if (onlyBlocked) {
        return oppUserBlocked;
      } else {
        return !oppUserBlocked;
      }
    }

    return false;
  }

  bool filterBlockedSearchQuery(
    Map<String, dynamic> chatData,
    String uid,
  ) {
    if (blockedFilter == null || blockedFilter!.isEmpty) {
      return true;
    }
    final participants = chatData['participants'] as List<dynamic>;
    final currentUserPosition = participants.indexOf(uid);

    if (currentUserPosition != -1) {
      final oppositePosition = (currentUserPosition + 1) % 2;
      final oppositeUsername = chatData['names'][oppositePosition] as String;

      return oppositeUsername
          .toLowerCase()
          .contains(blockedFilter!.toLowerCase());
    }

    return false;
  }

  bool filterChatSearchQuery(
    Map<String, dynamic> chatData,
    String uid,
  ) {
    if (chatFilter == null || chatFilter!.isEmpty) {
      return true;
    }
    final participants = chatData['participants'] as List<dynamic>;
    final currentUserPosition = participants.indexOf(uid);

    if (currentUserPosition != -1) {
      final oppositePosition = (currentUserPosition + 1) % 2;
      final oppositeUsername = chatData['names'][oppositePosition] as String;

      return oppositeUsername.toLowerCase().contains(chatFilter!.toLowerCase());
    }

    return false;
  }

  Future<void> toggleBlockedStatus({
    required String chatId,
    required int index,
    required bool newValue,
  }) async {
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final chatSnapshot = await chatRef.get();

    if (chatSnapshot.exists) {
      List<bool> userBlocked =
          List<bool>.from(chatSnapshot.data()!['userBlocked']);

      userBlocked[index] = newValue;

      await chatRef.update({'userBlocked': userBlocked});
      log('Updated blocked status properly to $newValue');
    } else {
      log('Chat not found.');
    }
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

  Future<void> confirmDeleteChat(String chatId) async {
    final chatReference =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    try {
      await chatReference
          .delete()
          .then((_) => log('Deleted chat from Firestore'));
    } on FirebaseException catch (e) {
      // Handle other errors
      log('A Firebase error occurred: $e');
    } catch (e) {
      log('A non Firebase Exception occurred ${e.toString()}');
    }
  }

  Future<void> toggleChatDeletionStatus(String chatId, bool delete) async {
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final chatSnapshot = await chatRef.get();
      final chatData = chatSnapshot.data();

      if (chatData == null) {
        // Document doesn't exist, handle accordingly
        log('Document $chatId does not exist.');
        return;
      }

      final participants = chatData['participants'] as List<dynamic>?;
      final deletedAccount = chatData['deletedAccount'] as List<dynamic>?;

      if (participants == null ||
          deletedAccount == null ||
          participants.length != deletedAccount.length) {
        log('Invalid data in the chat document.');
        return;
      }

      int currentUserIndex = participants.indexOf(userId);

      if (currentUserIndex == -1) {
        log('User $userId is not a participant in the chat.');
        return;
      }

      deletedAccount[currentUserIndex] = delete;

      chatRef.update({'deletedAccount': deletedAccount});
      log('Chat $chatId ${delete ? 'deleted' : 'undeleted'} successfully.');
    } catch (e) {
      log('Error undoing chat ${delete ? 'deleted' : 'undeleted'} : $e');
    }
  }
}
