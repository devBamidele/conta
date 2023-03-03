import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/new_user_data.dart';

class AuthenticationProvider extends ChangeNotifier {
  // Instantiate Firebase Firestore and Firebase Authentication
  final _fireStore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance;

  /// Holds the username
  String? username;
  String? email;
  String? password;

  setUsername(String? newName) {
    username = newName;
    notifyListeners();
  }

  setEmailAndPassword(String email, String password) {
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  getUserCredentials() {}

  UserData getUserData() {
    return UserData(
      username: username!,
      email: email!,
      password: password!,
    );
  }
}

/*
Future createAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: AppColors.primaryShadeColor,
          size: 60,
        ),
      ),
    );

    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: myEmailController.text.trim(),
        password: myPasswordController.text,
      );

      // Navigate to the
      this.context.router.push(SetNameScreenRoute(
            credential: userCredential,
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Handle weak password error
        AppUtils.showSnackbar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // Handle email already exists error
        AppUtils.showSnackbar('An account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        // Handle invalid email error
        AppUtils.showSnackbar('The email address is invalid.');
      } else {
        // Handle other FirebaseAuthException errors
        AppUtils.showSnackbar(
            'An error occurred while creating account. Please try again later.');
      }
    } on Exception {
      // Handle other exceptions
      AppUtils.showSnackbar(
          'An error occurred while creating account. Please try again later.');
    } finally {
      context.router.pop();
    }
  }

 */
