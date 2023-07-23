import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../models/person.dart';
import '../utils/app_utils.dart';
import 'secret_keys' as secret_key;

class AuthenticationProvider extends ChangeNotifier {
  // Instantiate Firebase Firestore and Firebase Authentication
  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String? username;
  String? name;

  String? email;
  String? password;

  File? profilePic;

  Future<void> createUser({
    required BuildContext context,
    required void Function(String) showSnackbar,
    required void Function(UserCredential) onAuthenticate,
    File? imageFile,
  }) async {
    final username = this.username!;
    final email = this.email!;
    final password = this.password!;

    AppUtils.showLoadingDialog(context);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
    AppUtils.showLoadingDialog(context);

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

  Future<void> checkEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
  }) async {
    AppUtils.showLoadingDialog(context);

    try {
      // Check if the email is already registered with Firebase
      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

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
    AppUtils.showLoadingDialog(context);

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

  String getCodeFromGitHubLink(String? link) =>
      link == null ? "" : link.substring(link.indexOf(RegExp('code=')) + 5);

  Future<UserCredential> loginWithGitHub(String code) async {
    final url = Uri.parse("https://github.com/login/oauth/access_token");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: "{\"client_id\":\"${secret_key.GITHUB_CLIENT_ID}\""
          ",\"client_secret\":\"${secret_key.GITHUB_CLIENT_SECRET}\""
          ",\"code\":\"$code\"}",
    );

    final AuthCredential credential = GithubAuthProvider.credential(
      json.decode(response.body)['access_token'],
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> loginWithGithub() async {
    Uri url = Uri.parse(
        "https://github.com/login/oauth/authorize?client_id=${secret_key.GITHUB_CLIENT_ID}"
        "&scope=public_repo%20read:user%20user:email");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
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

  setNameAndUserName(String name, String username) {
    this.name = name;
    this.username = username;
    notifyListeners();
  }

  setEmailAndPassword(String email, String password) {
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  // Todo : Check this out later
  // a method to check if the username already exists in Firestore
  Future<bool> checkIfUsernameExists(String username) async {
    // perform a query on the Firestore collection to check if the username already exists
    var result = await _fireStore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    // if the query returns any documents, it means the username already exists
    return result.docs.isNotEmpty;
  }
}
