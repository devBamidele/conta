import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/person.dart';
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

  Future<void> updateUserProfilePicture({required String? profilePic}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final baseUrl = Uri.parse(dotenv.env['UPDATE_PROFILE_PIC'] as String);

    final queryParameters = {
      'userId': userId,
      'profilePic': profilePic,
    };

    final url = baseUrl.replace(queryParameters: queryParameters);

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        log('Profile picture updated successfully.');
      } else {
        log('Failed to update profile picture. Status code: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      log('Error updating profile picture: $error');
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

      // Call the cloud function to update all the chats
      updateUserProfilePicture(profilePic: photoUrl);

      updatePicData(photoUrl);

      onUpdate();
    } catch (e) {
      log('Error updating profile pic $e');
      showSnackbar('An error occurred while updating the profile picture');
    } finally {
      // Close the loading dialog when login attempt is finished
      if (context.mounted) Navigator.of(context).pop();
    }
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

      // Call the cloud function to update all the chats
      updateUserProfilePicture(profilePic: null);

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
    required VoidCallback onDelete,
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

        await user.delete().then((value) => onDelete());

        showSnackbar('Successfully Deleted Account');
      } catch (e) {
        // Password is incorrect failed
        showSnackbar('Password is incorrect');

        log('Error: $e');
      } finally {
        // Close the loading dialog when login attempt is finished
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  Future<void> updateUsername(
    String newName, {
    required BuildContext context,
    required void Function(String) showSnackbar,
  }) async {
    AppUtils.showLoadingDialog1(context);

    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final user = auth.currentUser;
    if (user != null) {
      try {
        // Update the user's name in the Firestore database
        await firestore.collection('users').doc(user.uid).update({
          'username': newName,
        });

        // Successfully updated bio
        showSnackbar('Successfully updated name');
      } catch (error) {
        // Error updating bio
        showSnackbar('Error updating username');
      } finally {
        // Close the loading dialog when login attempt is finished
        if (context.mounted) Navigator.of(context).pop();
      }
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
      } finally {
        // Close the loading dialog when login attempt is finished
        if (context.mounted) Navigator.of(context).pop();
      }
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
}
