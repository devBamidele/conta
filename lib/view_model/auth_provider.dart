import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/person.dart';
import '../utils/app_utils.dart';

class AuthProvider extends ChangeNotifier {
  String? username;
  String? name;
  String? email;
  String? password;
  File? profilePic;

  void clearData() {
    username = null;
    name = null;
    email = null;
    password = null;
    profilePic = null;
  }

  void setNameAndUserName(String name, String username) {
    this.name = name;
    this.username = username;
    notifyListeners();
  }

  void clearCachedPic() {
    profilePic = null;
  }

  void setEmailAndPassword(String email, String password) {
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  /*
   Todo: I need to come back to this and find a way to make it case insensitive
   */
  Future<bool> isUsernameUnique(String username) async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    // if the query returns any documents, it means the username already exists
    return result.docs.isEmpty;
  }

  Future<bool> isPhoneUnique(String phone) async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phone)
        .get();

    // if the query returns any documents, it means the phone number already exists
    return result.docs.isEmpty;
  }

  Future<void> createNewUser(String userId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("profile_pictures")
          .child(userId);

      String? photoUrl;
      final file = profilePic;

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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(person);
    } catch (e) {
      log('An exception occurred while uploading the users profile picture ${e.toString()}');
      throw 'An error occurred while uploading the image';
    }
  }

  Future<void> updateUserToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();

    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      final userDoc = await userRef.get();

      // Check if the user document exists
      if (userDoc.exists) {
        final currentToken = userDoc.data()?['token'];

        // If the 'token' field is null or different from the new token, update it
        if (currentToken == null || currentToken != token) {
          await userRef.update({'token': token});
          log('User token updated successfully.');
        } else {
          log('User token is up to date.');
        }
      } else {
        log('User document does not exist.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserExists(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userDoc.exists;
  }

  Future<void> createUser({
    required BuildContext context,
    required void Function(String) showSnackbar,
    required void Function(UserCredential) onAuthenticate,
  }) async {
    final username = this.username!;
    final email = this.email!;
    final password = this.password!;

    AppUtils.showLoadingDialog1(context);

    try {
      // Email and password sign-in
      final credential =
          EmailAuthProvider.credential(email: email, password: password);

      final userCredential =
          await linkAnonymousUserWithEmailPassword(credential);

      if (userCredential == null) {
        showSnackbar('An error occurred while creating the user');
        return;
      }

      final userId = userCredential.user!.uid;

      // Upload the image and create the User in firestore
      createNewUser(userId);

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
      // Close the loading dialog when login attempt is finished
      if (context.mounted) Navigator.of(context).pop();
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
      // Close the loading dialog when login attempt is finished
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  // Function to link the anonymous user with the new credentials
  Future<UserCredential?> linkAnonymousUserWithEmailPassword(
    AuthCredential credential,
  ) async {
    try {
      // Get the currently signed-in anonymous user
      User? anonymousUser = FirebaseAuth.instance.currentUser;

      if (anonymousUser == null) {
        log('Anonymous user or new credentials not found');
        return null;
      }

      // Link the anonymous user with the new credentials
      UserCredential linkedCredential =
          await anonymousUser.linkWithCredential(credential);

      // Use the linkedCredential to get the updated user information
      User? user = linkedCredential.user;

      if (user != null) {
        // User successfully linked with new credentials
        log('User linked successfully with new credentials');
      } else {
        // Linking failed
        log('Linking with new credentials failed');
      }

      return linkedCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          log("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          log("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          log("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          log("Unknown error.");
      }
    } catch (e) {
      // Handle any errors that occur during linking
      log('Error during linking: $e');
    }
    return null;
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
    } on FirebaseException catch (e) {
      if (e.code == 'network-request-failed') {
        showSnackbar('Poor internet connection');
      } else {
        showSnackbar('Oops, an error occurred');
      }
    } catch (e) {
      // Handle exceptions
      showSnackbar('An error occurred while checking email and password.'
          ' Please try again later.');

      log(e.toString());
    } finally {
      // Close the loading dialog when login attempt is finished
      if (context.mounted) Navigator.of(context).pop();
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
        // Set up token for the user
        updateUserToken(user.uid);

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
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> loginWithGoogle({
    required BuildContext context,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
  }) async {
    AppUtils.showLoadingDialog1(context);

    try {
      // Sign in with Google and get user credential
      UserCredential? userCredential = await handleGoogleLogin();

      User? user = userCredential?.user;

      if (user == null) {
        return;
      }

      // Check if user is authenticated and email is verified
      if (!user.emailVerified) {
        showSnackbar('Please verify your email before logging in');
        return;
      }

      bool userExists = await checkUserExists(user.uid);

      if (!userExists) {
        showSnackbar('Account not registered with app');
        return;
      }

      // Set up token for the user
      updateUserToken(user.uid);

      onAuthenticate();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        showSnackbar('Account exists with different credential');
      } else if (e.code == 'invalid-credential') {
        showSnackbar('Invalid credential');
      } else {
        showSnackbar('An error occurred, please try again later 1');
      }
    } on SocketException {
      showSnackbar('No internet connection');
    } on UnregisteredEmailException catch (e) {
      showSnackbar(e.message);
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        showSnackbar('No internet connection');
      } else {
        showSnackbar('Oops, an error occurred. Try Again');
      }
    } catch (_) {
      showSnackbar('No account selected');
    } finally {
      // Close the loading dialog when login attempt is finished
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<UserCredential?> handleGoogleLogin() async {
    final isSignedIn = await GoogleSignIn().isSignedIn();

    if (isSignedIn) {
      await GoogleSignIn().disconnect();
    }

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // User canceled the Google sign-in
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Check if the email associated with the Google account is already registered
    final email = googleUser.email;

    // Check if the email is registered with the app
    final List<String> methods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

    if (methods.isEmpty) {
      throw UnregisteredEmailException('Account not registered with app');
    }

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class UnregisteredEmailException implements Exception {
  final String message;

  UnregisteredEmailException(this.message);
}
