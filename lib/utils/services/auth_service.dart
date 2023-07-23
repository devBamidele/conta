import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get userStream => _auth.authStateChanges();

  /// Updates the online status and last seen time of the currently
  /// logged-in user in Firestore.
  Future<void> updateUserOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;

    if (user != null) {
      try {
        final docRef = _firestore.doc('users/${user.uid}');

        // Check if the device is currently offline.
        ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();

        // If the device is online, update the status in Firestore.
        if (connectivityResult != ConnectivityResult.none) {
          await docRef.update({
            'online': isOnline,
            'lastSeen': DateTime.now(),
          });
        }
      } catch (e) {
        // Handle any exceptions that might occur while accessing Firestore or checking connectivity.
        log('Error updating user online status: $e');
      }
    }
  }

  Future<void> signOutFromApp() async {
    try {
      // Update user online status to false and sign out the user
      await updateUserOnlineStatus(false)
          .catchError((e) => log('Error updating user online status: $e'))
          .then((_) => _auth.signOut())
          .catchError((e) => log('Error signing out: $e'));
    } catch (e) {
      // Handle any other errors here
      log('Error: $e');
    }
  }
}
