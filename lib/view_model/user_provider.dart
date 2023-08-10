import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/Person.dart';

class UserProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Person? userData;

  Future<void> getUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final userSnapshot = await firestore.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        userData = Person.fromJson(userSnapshot.data()!);
      } else {
        log('User not found');
      }
    } catch (error) {
      log('Error fetching user info: $error');
    }
    notifyListeners();
  }

  Future<void> updateUserName(String uid, String newName) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'name': newName,
      });
      log('User name updated successfully');
    } catch (error) {
      log('Error updating user name: $error');
    }
  }

  Future<void> updateUserEmail(String uid, String newEmail) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'email': newEmail,
      });
      log('User email updated successfully');
    } catch (error) {
      log('Error updating user email: $error');
    }
  }

// Add other methods to update profile properties (e.g., profile picture, bio, etc.) as needed
}
