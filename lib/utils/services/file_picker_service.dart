import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class FilePickerService {
  /// Allows the user to pick media files and returns the selected files as a list of [PlatformFile] objects.
  ///
  /// Throws an error if there is any issue during the file picking process.
  Future<List<PlatformFile>?> pickImages(String chatId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        List<PlatformFile> validFiles = [];

        for (PlatformFile file in result.files) {
          validFiles.add(file);
        }

        // Process or send the selected file
        return validFiles;
      }
    } on PlatformException catch (e) {
      if (e.code == 'read_external_storage_denied') {
        throw 'Storage access denied.\nPlease grant storage permissions.';
      } else {
        throw 'An error occurred while picking the file. Please try again later.';
      }
    } catch (_) {
      throw 'An error occurred while picking the file. Please try again later.';
    }
    return null;
  }

  /// Uploads multiple photos to Firebase Storage and returns their download URLs.
  ///
  /// Returns a [Future] that completes with a list of download URLs for the uploaded photos,
  /// or `null` if no photos were uploaded.
  ///
  /// Throws an error if there is any issue during the photo upload process, such as an invalid file type.
  Future<List<String>?> getDownloadUrls({
    required List<String> photoPaths,
    required String chatId,
  }) async {
    try {
      final storageInstance = FirebaseStorage.instanceFor(
        bucket: 'gs://conta---instant-messaging-app-appimages',
      );

      final List<String> photoUrls = await Future.wait(
        photoPaths.map(
          (photoPath) async {
            final mediaId = const Uuid().v4();
            final photoFile = File(photoPath);

            final baseName = path.basenameWithoutExtension(photoPath);
            final refPath = 'images/chats/$chatId/$mediaId/$baseName';

            await storageInstance.ref(refPath).putFile(photoFile);

            return await storageInstance.ref(refPath).getDownloadURL();
          },
        ),
      );

      return photoUrls.isNotEmpty ? photoUrls : null;
    } catch (e) {
      log(e.toString());
      throw 'Error uploading photos: $e';
    }
  }

  /// Deletes files from Firebase Storage based on the provided list of file URLs.
  Future<void> deleteFilesFromStorage(List<String> fileUrls) async {
    try {
      for (String fileUrl in fileUrls) {
        // Get a reference to the file in Firebase Storage
        final storageRef = FirebaseStorage.instanceFor(
          bucket: 'gs://conta---instant-messaging-app-appimages',
        ).refFromURL(fileUrl);

        // Delete the file
        await storageRef.delete().then((value) => log('Deleted $fileUrl'));
      }
    } catch (e) {
      // Handle the error
      log('Error deleting file');
    }
  }
}
