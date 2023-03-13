import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get userStream => _auth.authStateChanges();

  Future<void> updateUserOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.doc('users/${user.uid}').update({
        'online': isOnline,
        'lastSeen': DateTime.now(),
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    updateUserOnlineStatus(false);
  }
}
