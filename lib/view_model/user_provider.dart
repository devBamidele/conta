import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/Person.dart';
import '../utils/app_utils.dart';

class UserProvider extends ChangeNotifier {
  Person? userData;

  Future<void> getUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

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

  Future<void> deleteAccount({
    required BuildContext context,
    required String password,
    required void Function(String) showSnackbar,
  }) async {
    AppUtils.showLoadingDialog1(context);

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create an EmailAuthCredential object
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      try {
        await user.reauthenticateWithCredential(credential);

        // Password is correct, proceed with your logic
        showSnackbar('Successfully Deleted Account');
      } catch (e) {
        // Password is incorrect failed
        showSnackbar('Password is incorrect');

        log('Error: $e');
      } finally {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> updateBio(String newBio, {required BuildContext context}) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final user = auth.currentUser;
    if (user != null) {
      try {
        // Update the user's bio in the Firestore database
        await firestore.collection('users').doc(user.uid).update({
          'bio': newBio,
        });

        // Successfully updated bio
        log('Successfully updated bio');
      } catch (error) {
        log('Error updating bio $error');
        // Error updating bio
      }
    }
  }
// Add other methods to update profile properties (e.g., profile picture, bio, etc.) as needed
}
