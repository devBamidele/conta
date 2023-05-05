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

        if (connectivityResult == ConnectivityResult.none) {
          // If the device is offline, save the status update locally.
          // This ensures that the user's online status is still updated even if the device is offline.
          await docRef.set({
            'online': isOnline,
            'lastSeen': DateTime.now(),
          }, SetOptions(merge: true));
        } else {
          // If the device is online, update the status in Firestore.
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
      await updateUserOnlineStatus(false);
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        // Handle network connection errors here
        log('Error: ${e.code}. Please check your internet connection.');
      }
    } catch (e) {
      // Handle any other errors here
      log('Error: $e');
    }
  }
}
