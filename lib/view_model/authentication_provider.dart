import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  // Instantiate Firebase Firestore and Firebase Authentication
  final _fireStore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance;

  /// Holds the username
  String? username;

  setUsername(String? newName) {
    username = newName;
    notifyListeners();
  }
}
