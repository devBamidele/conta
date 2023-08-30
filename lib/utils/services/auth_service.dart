import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Updates the online status and last seen time of the currently
  /// logged-in user in Firestore.
  Future<void> updateUserOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      try {
        final docRef = _firestore.doc('users/${user.uid}');

        await docRef.update({
          'online': isOnline,
          'lastSeen': DateTime.now(),
        });
      } catch (e) {
        // Handle any exceptions that might occur while accessing Firestore or checking connectivity.
        log('Error updating user online status: $e');
      }
    }
  }

  Future<void> resetUserToken() async {
    final userId = _auth.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      await userRef.update({'token': null});
      log('User token reset successfully.');
    } catch (e) {
      log('Error resetting user token: $e');
    }
  }

  Future<void> signOutFromApp() async {
    try {
      // Update user online status to false and sign out the user
      await updateUserOnlineStatus(false)
          .catchError((e) => log('Error updating user online status: $e'))
          .then((value) => resetUserToken())
          .catchError((e) => log('Error deleting token $e'))
          .then((_) => _auth.signOut())
          .catchError((e) => log('Error signing out: $e'));
    } catch (e) {
      // Handle any other errors here
      log('Error: $e');
    }
  }
}
