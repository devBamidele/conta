import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/Person.dart';
import '../utils/app_utils.dart';

class UserProvider extends ChangeNotifier {
  Person? userData;

  File? profilePic;

  void clearProfilePic() {
    profilePic = null;
  }

  void updateNameData(String newBio) {
    if (userData != null) {
      userData = userData!.copy(bio: newBio);
      notifyListeners();
    }
  }

  void updatePicData(String? newUrl) {
    if (userData != null) {
      userData = userData!.copy(profilePicUrl: newUrl);
      notifyListeners();
    }
  }

  Future<void> updateProfilePic({
    required BuildContext context,
    required void Function(String) showSnackbar,
    required void Function() onUpdate,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    AppUtils.showLoadingDialog1(context);

    try {
      final ref = storage.ref().child("profile_pictures").child(userId);

      String? photoUrl;
      final file = profilePic;

      if (file != null) {
        await ref.putFile(file);
        photoUrl = await ref.getDownloadURL();
      }

      final docRef = firestore.doc('users/$userId');

      await docRef.update({
        'profilePicUrl': photoUrl,
      });

      updatePicData(photoUrl);

      onUpdate();
    } catch (e) {
      log('Error updating profile pic $e');
      showSnackbar('An error occurred while updating the profile picture');
    }
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> removeProfilePic({
    required void Function(String) showSnackbar,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    try {
      final picRef = storage.ref().child("profile_pictures").child(userId);

      final docRef = firestore.doc('users/$userId');

      await docRef.update({
        'profilePicUrl': null,
      });

      picRef.delete().then((value) => log('Deleted file successfully'));

      updatePicData('null');
    } catch (e) {
      log('Error removing profile pic $e');
      showSnackbar('An error occurred while removing the profile picture');
    }
  }

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

  Stream<String?> getProfilePic() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final CollectionReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users');

    return userRef.doc(userId).snapshots().map((snapshot) {
      return Person.fromJson(snapshot.data() as Map<String, dynamic>)
          .profilePicUrl;
    });
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
      }
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> updateBio(
    String newBio, {
    required BuildContext context,
    required void Function(String) showSnackbar,
  }) async {
    AppUtils.showLoadingDialog1(context);

    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final user = auth.currentUser;
    if (user != null) {
      try {
        // Update the user's bio in the Firestore database
        await firestore.collection('users').doc(user.uid).update({
          'bio': newBio,
        });

        updateNameData(newBio);

        // Successfully updated bio
        showSnackbar('Successfully updated bio');
      } catch (error) {
        // Error updating bio
        showSnackbar('Error updating bio');
      }
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> updateUserName(String uid, String newName) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': newName,
      });
      log('User name updated successfully');
    } catch (error) {
      log('Error updating user name: $error');
    }
  }

  Future<void> updateUserEmail(String uid, String newEmail) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'email': newEmail,
      });
      log('User email updated successfully');
    } catch (error) {
      log('Error updating user email: $error');
    }
  }

// Add other methods to update profile properties (e.g., profile picture, bio, etc.) as needed
}
