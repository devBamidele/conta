import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/Person.dart';
import '../models/search_user.dart';

class SearchProvider extends ChangeNotifier {
  Stream<List<Person>> getSuggestionsStream(
    String filter,
    String currentUserID, {
    int limit = 10,
  }) {
    return FirebaseFirestore.instance
        .collection('users')
        .limit(limit)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Person.fromJson(doc.data()))
          .where(
            (person) =>
                person.username.toLowerCase().contains(filter.toLowerCase()) &&
                person.id != currentUserID,
          )
          .toList();
    });
  }

//
  Future<void> addToRecentSearch({required Person person}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userQuery = await FirebaseFirestore.instance
        .collection('recent_searches')
        .where('username', isEqualTo: person.username)
        .where('uidUser', isEqualTo: userId)
        .get();

    if (userQuery.docs.isEmpty) {
      // If the user doesn't exist, add them as a new user
      final search = SearchUser(
        timestamp: Timestamp.now(),
        name: person.name,
        uidUser: userId,
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
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final batch = FirebaseFirestore.instance.batch();
    final firestore = FirebaseFirestore.instance;

    final querySnapshot = await firestore
        .collection('recent_searches')
        .where('uidUser', isEqualTo: userId)
        .get();

    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> deleteFromRecentSearch({required String username}) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

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
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('recent_searches')
        .where('uidUser', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => SearchUser.fromMap(doc.data()))
            .toList());
  }
}
