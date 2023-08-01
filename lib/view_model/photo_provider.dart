import 'package:flutter/material.dart';

class PhotoProvider extends ChangeNotifier {
  /*
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

  Future<void> uploadImagesAndCaption(String caption) async {
    final filePickerService = FilePickerService();
    final photoPaths =
    pickerResult.map((file) => file.path).whereType<String>().toList();

    final uIds = generateUniqueIds(photoPaths.length);

    try {
      final results = await filePickerService.uploadPhotosToStorage(
        chatId: currentChat!.chatId!,
        photoPaths: photoPaths,
        uIds: uIds,
      );
      await uploadChat(caption,
          type: MessageType.media, media: results, uIds: uIds);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFilesFromStorage() async {
    final filePickerService = FilePickerService();
    final fileUrls = <String>[];

    try {
      // Extract media URLs from each message in deletedMessages
      for (final message in deletedMessages) {
        final media = message.media;
        if (media != null) {
          fileUrls.addAll(media);
        }
      }

      // Delete the files from storage
      await filePickerService.deleteFilesFromStorage(fileUrls);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> chooseFiles() async {
    final filePickerService = FilePickerService();
    final id = currentChat!.chatId!;
    try {
      final result = await filePickerService.pickImages(id);

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
   */
}
