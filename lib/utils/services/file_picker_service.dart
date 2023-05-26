import 'dart:developer';
import 'dart:io';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class FilePickerService {
  final _storage = FirebaseStorage.instance;

  Future<FilePickerResult?> pickFile(String chatId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // Process or send the selected file
        return result;
        // _sendFiles(result.files, chatId);
      }
    } on PlatformException catch (e) {
      if (e.code == 'read_external_storage_denied') {
        throw 'Storage access denied.\n Please grant storage permissions.';
      } else {
        throw 'An error occurred while picking the file. Please try again later.';
      }
    } catch (_) {
      throw 'An error occurred while picking the file. Please try again later.';
    }
    return null;
  }

  Future<FilePickerResult?> checkPermissionAndPickFile(String chatId) async {
    final PermissionStatus status = await Permission.storage.status;
    FilePickerResult? result;

    if (status.isGranted) {
      result = await pickFile(chatId);
    } else {
      final PermissionStatus requestStatus = await Permission.storage.request();
      if (requestStatus.isGranted) {
        result = await pickFile(chatId);
      } else {
        throw 'Storage access denied. Please grant storage permissions.';
      }
    }
    return result;
  }

  Future<List<String>?> _uploadFilesToStorage({
    required List<String> filePaths,
    required String chatId,
  }) async {
    try {
      final List<Future<String>> uploadTasks = filePaths.map((filePath) async {
        final imageId = const Uuid().v4();
        final file = File(filePath);
        final ref =
            _storage.ref('chats/$chatId/$imageId/${file.path.split('/').last}');
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() {});
        return snapshot.ref.getDownloadURL();
      }).toList();

      final List<String> fileUrls = await Future.wait(uploadTasks);

      return fileUrls.isNotEmpty ? fileUrls : null;
    } catch (e) {
      // Handle any errors during file upload
      throw 'Error uploading file: $e';
    }
  }

  Future<void> _sendFiles(List<PlatformFile> files, String chatId) async {
    try {
      final filePaths = files.map((file) => file.path).toList();

      // Check if any of the filePaths is null
      if (filePaths.any((path) => path == null)) {
        throw 'One or more file paths are null.';
      }

      // Upload the files to storage (e.g., Firebase Storage) and get the file URLs
      final fileUrls = await _uploadFilesToStorage(
          filePaths: filePaths.cast<String>(), chatId: chatId);

      log('The file urls $fileUrls');

      // Send a message with the file URL to the chat
      //chatProvider.sendMessage(fileUrl);
    } catch (e) {
      rethrow;
    }
  }
}
