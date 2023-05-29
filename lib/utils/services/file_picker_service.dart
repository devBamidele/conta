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
        type: FileType.media, // Only allow media files (videos and pictures)
      );

      if (result != null && result.files.isNotEmpty) {
        List<PlatformFile> validFiles = [];
        int maxSizeInBytes = 100 * 1024 * 1024; // 100MB limit
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

  /// Uploads multiple files to Firebase Storage and returns their download URLs.
  ///
  /// The [filePaths] parameter specifies a list of file paths to be uploaded.
  /// The [chatId] parameter represents the ID of the chat associated with the files.
  ///
  /// Returns a [Future] that completes with a list of download URLs for the uploaded files,
  /// or `null` if no files were uploaded.
  ///
  /// Throws an error if there is any issue during the file upload process.
  Future<List<String>?> _uploadFilesToStorage({
    required List<String> filePaths,
    required String chatId,
  }) async {
    try {
      final List<Future<String>> uploadTasks = filePaths.map((filePath) async {
        final mediaId = const Uuid().v4();
        final file = File(filePath);
        final isPhoto = _isPhotoFile(file); // Check if it's a photo file

        // Depending on the file type, the file will be sent to a specified bucket
        final bucketName = isPhoto
            ? 'gs://conta---instant-messaging-app-appimages' // Bucket for photo files
            : null; // Default bucket for other files

        final baseName = path.basenameWithoutExtension(filePath);

        // Extract the reference as a string
        String refPath = isPhoto ? 'images/' : '';
        refPath += 'chats/$chatId/$mediaId/$baseName';

        String resizedPath = isPhoto
            ? 'images/chats/$chatId/$mediaId/resized/${baseName}_600x600'
            : refPath;

        final storageInstance = FirebaseStorage.instanceFor(bucket: bucketName);

        // Handle the upload and get the download URL
        await storageInstance.ref(refPath).putFile(file);

        // I need to place the delay here
        await Future.delayed(const Duration(milliseconds: 1200));

        final resizedDownloadUrl =
            await storageInstance.ref(resizedPath).getDownloadURL();

        log(resizedDownloadUrl);

        return resizedDownloadUrl; // Return the download URL
      }).toList();

      final List<String> fileUrls = await Future.wait(uploadTasks);

      return fileUrls.isNotEmpty ? fileUrls : null;
    } catch (e) {
      // Handle any errors during file upload
      throw 'Error uploading file: $e';
    }
  }

  bool _isPhotoFile(File file) {
    // Implement your file type check logic here
    // Example implementation:
    final extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  Future<List<String>?> sendFiles(
      List<PlatformFile> files, String chatId) async {
    try {
      final filePaths = files.map((file) => file.path).toList();

      // Check if any of the filePaths is null
      if (filePaths.any((path) => path == null)) {
        throw 'One or more file paths are null.';
      }
      // Upload the files to storage (e.g., Firebase Storage) and return the file URLs
      return _uploadFilesToStorage(
          filePaths: filePaths.cast<String>(), chatId: chatId);
    } catch (e) {
      rethrow;
    }
  }
}
