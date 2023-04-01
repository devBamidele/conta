import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/person.dart';

class AuthenticationProvider extends ChangeNotifier {
  // Instantiate Firebase Firestore and Firebase Authentication
  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String? username;
  String? name;

  String? email;
  String? password;

  File? profilePic;

  Future<UserCredential> signInWithGoogle() async {
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

  Future<UserCredential> signInWithGitHub() async {
    // Create a new provider
    GithubAuthProvider githubProvider = GithubAuthProvider();

    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
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
        chats: [],
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
