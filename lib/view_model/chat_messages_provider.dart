import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conta/models/chat.dart';
import 'package:conta/data/sample_messages.dart';

import '../models/message.dart';
import '../models/search_user.dart';

class ChatMessagesProvider extends ChangeNotifier {
  final currentUser = FirebaseAuth.instance.currentUser;

  /// Get the messages as a json response and return a list of Json objects
  List<Chat> getMessages() {
    return Sample.sampleMessages.map((e) => Chat.fromJson(e)).toList();
  }

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

  /// Get a list of suggestions as the user types
  Stream<List<String>> getSuggestionsStream(String filter) {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => doc['name'] as String)
          .where((name) => name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    });
  }

  addToRecentSearch({required String name}) {
    final user = SearchUser(
      timestamp: Timestamp.now(),
      name: name,
      uid: currentUser!.uid,
    );

    FirebaseFirestore.instance.collection('recent_searches').add(
          user.toMap(),
        );
  }

  void deleteFromRecentSearch({required String name}) async {
    final uid = currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('recent_searches')
        .where('name', isEqualTo: name)
        .where('uid', isEqualTo: uid)
        .get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }

  Stream<List<SearchUser>> getRecentSearches() {
    return FirebaseFirestore.instance
        .collection('recent_searches')
        .where('uid', isEqualTo: currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => SearchUser.fromMap(doc.data()))
            .toList());
  }

  /// Holds the profile information of the current selected chat
  Chat? currentChat;
}
