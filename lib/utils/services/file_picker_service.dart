import 'dart:developer';
import 'dart:io';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:conta/utils/app_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class FilePickerService {
  /// Allows the user to pick media files and returns the selected files as a list of [PlatformFile] objects.
  ///
  /// The [chatId] parameter represents the ID of the chat associated with the picked files.
  ///
  /// Returns a [Future] that completes with the list of selected files if at least one file was picked,
  /// or `null` if no files were picked.
  ///
  /// Throws an error if there is any issue during the file picking process.
  Future<List<PlatformFile>?> pickFile(String chatId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image, // Only allow only pictures
      );

      if (result != null && result.files.isNotEmpty) {
        List<PlatformFile> validFiles = [];
        int maxSizeInBytes = 50 * 1024 * 1024; // 50MB limit
        int filesExceedingSizeLimit = 0;

        for (PlatformFile file in result.files) {
          if (file.size <= maxSizeInBytes) {
            validFiles.add(file);
          } else {
            filesExceedingSizeLimit++;
          }
        }

        if (filesExceedingSizeLimit > 0) {
          AppUtils.showSnackbar(
              '$filesExceedingSizeLimit file(s) exceeded the size limit.');
        }

        // Process or send the selected file
        return validFiles;
        // _sendFiles(result.files, chatId);
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

  /// Checks the storage permission and invokes [pickFile] to pick files if the permission is granted.
  ///
  /// The [chatId] parameter represents the ID of the chat associated with the picked files.
  ///
  /// Returns a [Future] that completes with the list of selected files if at least one file was picked,
  /// or `null` if no files were picked.
  ///
  /// Throws an error if the storage access is denied.
  Future<List<PlatformFile>?> checkPermissionAndPickFile(String chatId) async {
    final PermissionStatus status = await Permission.storage.status;
    List<PlatformFile>? result;

    if (status.isGranted) {
      result = await pickFile(chatId);
    } else {
      final PermissionStatus requestStatus = await Permission.storage.request();
      if (requestStatus.isGranted) {
        result = await pickFile(chatId);
      } else {
        throw 'Storage access denied.';
      }
    }
    return result;
  }

  /// Uploads multiple photos to Firebase Storage and returns their download URLs.
  ///
  /// The [photoPaths] parameter specifies a list of file paths to the photos to be uploaded.
  /// The [chatId] parameter represents the ID of the chat associated with the photos.
  ///
  /// Returns a [Future] that completes with a list of download URLs for the uploaded photos,
  /// or `null` if no photos were uploaded.
  ///
  /// Throws an error if there is any issue during the photo upload process, such as an invalid file type.
  ///
  /// Note: This function assumes that the file paths in [photoPaths] represent valid
  /// file locations on the device. Make sure the photos exist before invoking this function.
  Future<List<String>?> uploadPhotosToStorage({
    required List<String> photoPaths,
    required String chatId,
    required List<String> uIds,
  }) async {
    try {
      final List<String> photoUrls = await Future.wait(
        photoPaths.asMap().entries.map((entry) async {
          final int index = entry.key;
          final String photoPath = entry.value;
          String messageId = '';

          final mediaId = const Uuid().v4();
          final photoFile = File(photoPath);

          log('The media ID is: $mediaId');

          // Check if it's a photo file
          final isPhoto = _isPhotoFile(photoFile);
          if (!isPhoto) {
            throw 'Invalid file type: $photoPath';
          }

          if (uIds.length > 3) {
            messageId = uIds[0];
          } else {
            messageId = uIds[index];
          }

          final metadata = SettableMetadata(
            customMetadata: {
              'messageId': messageId,
            },
          );

          final baseName = path.basenameWithoutExtension(photoPath);
          final refPath = 'images/chats/$chatId/$mediaId/$baseName';

          final storageInstance = FirebaseStorage.instanceFor(
            bucket: 'gs://conta---instant-messaging-app-appimages',
          );

          await storageInstance.ref(refPath).putFile(photoFile, metadata);

          final downloadUrl =
              await storageInstance.ref(refPath).getDownloadURL();

          log(downloadUrl);
          return downloadUrl;
        }),
      );

      return photoUrls.isNotEmpty ? photoUrls : null;
    } catch (e) {
      throw 'Error uploading photos: $e';
    }
  }

  bool _isPhotoFile(File file) {
    // Implement your file type check logic here
    // Example implementation:
    final extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  /// Deletes files from Firebase Storage based on the provided list of file URLs.
  ///
  /// The [fileUrls] parameter is a list of file URLs to be deleted.
  /// Each file URL should be a valid Firebase Storage URL.
  /// Throws an exception if the URL format is invalid or if any error occurs during the deletion process.
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
