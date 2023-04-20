import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;

import 'secret_keys' as secret_key;
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> githubLogin() async {
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
