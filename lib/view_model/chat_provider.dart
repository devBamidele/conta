import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/models/chat.dart';
import 'package:conta/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/Person.dart';
import '../utils/services/contacts_service.dart';

class ChatProvider extends ChangeNotifier {
  List<String?> phoneNumbers = [];

  String? _chatFilter;

  String? get chatFilter => _chatFilter;

  set chatFilter(String? value) {
    _chatFilter = value;

    notifyListeners();
  }

  String? _contactFilter;

  String? get contactFilter => _contactFilter;

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
}
