import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conta/models/chat.dart';

import '../models/Person.dart';
import '../models/current_chat.dart';
import '../models/message.dart';
import '../models/search_user.dart';

class ChatMessagesProvider extends ChangeNotifier {
  final currentUser = FirebaseAuth.instance.currentUser;

  Stream<List<Message>> getChatMessagesStream(
    String currentUserUid,
    String otherUserUid,
  ) {
    CollectionReference chatRef =
        FirebaseFirestore.instance.collection('chats');
    String chatId = generateChatId(
      currentUserUid,
      otherUserUid,
    ); // Generate a unique chat id between the two users

    return chatRef
        .doc(chatId)
        .collection('messages')
        .orderBy(
          'timestamp',
          descending: true,
        ) // Order messages by timestamp in descending order
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Message.fromJson(doc.data()))
            .toList());
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
      );
      await FirebaseFirestore.instance
          .collection('recent_searches')
          .add(search.toMap());
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
    required String uidUser,
    required String uidChat,
    String? profilePicUrl,
  }) {
    final chat = CurrentChat(
      username: username,
      uidUser: uidUser,
      uidChat: uidChat,
      profilePicUrl: profilePicUrl,
    );
    currentChat = chat;
  }

  /// Holds the profile information of the current selected chat
  CurrentChat? currentChat;
}
