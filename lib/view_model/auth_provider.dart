import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/person.dart';
import '../utils/app_utils.dart';

class AuthProvider extends ChangeNotifier {
  // Instantiate Firebase Firestore and Firebase Authentication
  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String? username;
  String? name;
  String? email;
  String? password;
  File? profilePic;

  void setNameAndUserName(String name, String username) {
    this.name = name;
    this.username = username;
    notifyListeners();
  }

  void clearAll() {}

  void clearCachedPic() {
    profilePic = null;
  }

  void setEmailAndPassword(String email, String password) {
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  // a method to check if the username already exists in Firestore
  Future<bool> isUnique(String username) async {
    // perform a query on the Firestore collection to
    // check if the username already exists
    var result = await _fireStore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    log('Query executed');

    // if the query returns any documents, it means the username already exists
    return result.docs.isEmpty;
  }

  Future<void> createNewUser(String userId, File? file) async {
    try {
      final ref = _storage.ref().child("profile_pictures").child(userId);
      String? photoUrl;

      // Upload the image to firebase cloud storage
      // And the download Url
      if (file != null) {
        await ref.putFile(file);
        photoUrl = await ref.getDownloadURL();
      }

      final person = Person(
        id: userId,
        name: name!,
        username: username!,
        email: email!,
        profilePicUrl: photoUrl,
        lastSeen: Timestamp.now(),
      ).toJson();

      await _fireStore.collection('users').doc(userId).set(person);
    } catch (e) {
      throw 'An error occurred while uploading the image';
    }
  }

  Future<void> createUser({
    required BuildContext context,
    required void Function(String) showSnackbar,
    required void Function(UserCredential) onAuthenticate,
    File? imageFile,
  }) async {
    final username = this.username!;
    final email = this.email!;
    final password = this.password!;

    AppUtils.showLoadingDialog1(context);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await linkAnonymousUserWithEmailPassword(userCredential);

      final userId = userCredential.user!.uid;

      // Upload the image and create the User in firestore
      createNewUser(userId, imageFile);

      // Update the display name
      await userCredential.user!.updateDisplayName(username);

      // Send email verification to new user
      await userCredential.user!.sendEmailVerification();

      onAuthenticate(userCredential);
    } catch (e) {
      // Handle exceptions
      if (e.toString() == 'An error occurred while uploading the image') {
        showSnackbar(e.toString());
      } else {
        showSnackbar('An error occurred while creating the account. '
            'Please try again later.');
      }
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> sendPasswordResetEmail({
    required BuildContext context,
    required String email,
    required void Function(String) showSnackbar,
    required void Function(String) onAuthenticate,
  }) async {
    AppUtils.showLoadingDialog1(context);

    try {
      // Check if the email is registered with the app
      final auth = FirebaseAuth.instance;
      final List<String> methods = await auth.fetchSignInMethodsForEmail(email);

      if (methods.isNotEmpty) {
        // Send password reset email
        await auth.sendPasswordResetEmail(email: email).then(
              (value) => showSnackbar('Sent verification email'),
            );

        // Navigate to the password reset page
        onAuthenticate(email);
      } else {
        // Email is not registered with the app
        showSnackbar('Email is not registered with the app');
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'network-request-failed') {
        // Handle network error specifically
        showSnackbar(
            'A network error has occurred. Please check your internet connection.');
      } else {
        // Handle other exceptions
        showSnackbar('Error sending password reset email');
      }
    } finally {
      Navigator.of(context).pop();
    }
  }

  // Function to link the anonymous user with the new credentials
  Future<void> linkAnonymousUserWithEmailPassword(
    UserCredential newCredential,
  ) async {
    try {
      // Get the currently signed-in anonymous user
      User? anonymousUser = FirebaseAuth.instance.currentUser;

      if (anonymousUser == null || newCredential.user == null) {
        log('Anonymous user or new credentials not found');
        return;
      }

      // Link the anonymous user with the new credentials
      UserCredential linkedCredential =
          await anonymousUser.linkWithCredential(newCredential.credential!);

      // Use the linkedCredential to get the updated user information
      User? user = linkedCredential.user;

      if (user != null) {
        // User successfully linked with new credentials
        log('User linked successfully with new credentials');
      } else {
        // Linking failed
        log('Linking with new credentials failed');
      }
    } catch (e) {
      // Handle any errors that occur during linking
      log('Error during linking: $e');
    }
  }

  Future<void> anonymousSignIn() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();

      final uid = FirebaseAuth.instance.currentUser!;

      log("Signed in with temporary account. Uid : $uid");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          log("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          log("Unknown error.");
      }
    }
  }

  Future<void> checkEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
  }) async {
    AppUtils.showLoadingDialog1(context);

    try {
      // Check if the email is already registered with Firebase
      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // Sign in the user anonymously
      await anonymousSignIn();

      if (signInMethods.isNotEmpty) {
        // Email is already registered with Firebase
        showSnackbar('An account already exists for that email.');
      } else {
        setEmailAndPassword(email, password);

        onAuthenticate();
      }
    } catch (e) {
      // Handle exceptions
      showSnackbar('An error occurred while checking email and password.'
          ' Please try again later.');
    } finally {
      // Close the loading dialog when login attempt is finished
      Navigator.of(context).pop();
    }
  }

  Future<void> loginWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
  }) async {
    AppUtils.showLoadingDialog1(context);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // User is authenticated and email is verified
      if (user != null && user.emailVerified) {
        // Set One Signal id for the User
        //_messagingService.setExternalUserId(user.uid);

        onAuthenticate();
      } else {
        // Email is not verified
        showSnackbar('Please verify your email before logging in');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        // User's device is not connected to the internet,
        showSnackbar('No internet connection');
      } else {
        // Handle login errors
        showSnackbar('Invalid email or password');
      }
    } catch (e) {
      // Handle other errors
      showSnackbar('An error occurred while checking email and password. '
          'Please try again later.');
    } finally {
      // Close the loading dialog when login attempt is finished
      Navigator.of(context).pop();
    }
  }

  Future<void> loginWithGoogle({
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
  }) async {
    try {
      // Sign in with Google and get user credential
      UserCredential userCredential = await handleGoogleLogin();
      User? user = userCredential.user;

      // Check if user is authenticated and email is verified
      if (user == null || !user.emailVerified) {
        showSnackbar('Please verify your email before logging in');
        return;
      }

      // Set One Signal id for the User
      //_messagingService.setExternalUserId(user.uid);

      onAuthenticate();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        showSnackbar('Account exists with different credential');
      } else if (e.code == 'invalid-credential') {
        showSnackbar('Invalid credential');
      } else {
        showSnackbar('An error occurred, please try again later');
      }
    } on SocketException {
      showSnackbar('No internet connection');
    } catch (_) {
      showSnackbar('An error occurred, please try again later');
    }
  }

  Future<UserCredential> handleGoogleLogin() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
