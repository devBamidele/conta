import 'dart:developer';

import 'package:conta/view_model/chat_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../utils/app_utils.dart';
import '../utils/enums.dart';
import '../utils/services/file_picker_service.dart';

class PhotoProvider extends ChangeNotifier {
  List<PlatformFile> pickerResult = [];

  List<String> generateUniqueIds(int number) {
    final List<String> uniqueIds = [];

    if (number > 0) {
      if (number == 1) {
        uniqueIds.add(const Uuid().v4());
      } else if (number >= 2 && number <= 3) {
        for (int i = 0; i < number; i++) {
          final String uniqueId = const Uuid().v4();
          if (!uniqueIds.contains(uniqueId)) {
            uniqueIds.add(uniqueId);
          }
        }
      } else if (number >= 4) {
        uniqueIds.add(const Uuid().v4());
      }
    }

    return uniqueIds;
  }

  void removeFileFromPicker(int index) {
    pickerResult.removeAt(index);
    notifyListeners();
  }

  void clearPickerResult() async {
    pickerResult.clear();
    final success = await FilePicker.platform.clearTemporaryFiles();

    if (success != null && success == true) {
      log('Successfully able to clear cache');
    } else {
      log('Unable to clear cache');
    }
  }

  Future<void> sendImagesAndCaption({
    required BuildContext context,
    required String caption,
    required void Function(String) showSnackbar,
    required VoidCallback onUpload,
  }) async {
    AppUtils.showLoadingDialog2(context);
    try {
      await uploadImagesAndCaption(caption, context);
    } catch (e) {
      showSnackbar(e.toString());
    } finally {
      clearPickerResult();
      onUpload();
    }
  }

  Future<void> uploadImagesAndCaption(
    String caption,
    BuildContext context,
  ) async {
    final filePickerService = FilePickerService();
    final photoPaths =
        pickerResult.map((file) => file.path).whereType<String>().toList();

    final uIds = generateUniqueIds(photoPaths.length);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final chatId = chatProvider.currentChat!.chatId!;

    try {
      final urls = await filePickerService.getDownloadUrls(
        chatId: chatId,
        photoPaths: photoPaths,
      );

      await chatProvider.uploadChat(
        caption,
        type: MessageType.media,
        media: urls,
        uIds: uIds,
      );
    } catch (e) {
      rethrow;
    }
  }

  void getImages({
    required VoidCallback onPick,
    required void Function(String) showToast,
  }) async {
    // Clear picker result first
    clearPickerResult();

    try {
      final result = await chooseFiles();
      if (result) {
        onPick();
      }
      return;
    } catch (e) {
      showToast(e.toString());
    }
  } //

  Future<bool> chooseFiles() async {
    final filePickerService = FilePickerService();
    try {
      final result = await filePickerService.pickImages();

      if (result != null && result.isNotEmpty) {
        pickerResult.addAll(result);

        notifyListeners();
        return true;
      }
    } catch (e) {
      rethrow;
    }
    return false;
  }
}
