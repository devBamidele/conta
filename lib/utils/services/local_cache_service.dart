import 'dart:io';

import 'package:conta/utils/extensions.dart';
import 'package:http/http.dart' as http;

class LocalCacheService {
  static Future<File?> checkLocalFile(String mediaUrl, String dir) async {
    final fileName = mediaUrl.getFileName();

    final storageDir = Directory(dir);
    final localFile = File('${storageDir.path}/$fileName');

    if (await localFile.exists()) {
      return localFile;
    } else {
      return _downloadAndSaveImage(dir, mediaUrl, fileName);
    }
  }

  static Future<File?> _downloadAndSaveImage(
      String dir, String mediaUrl, String fileName) async {
    try {
      final response = await http.get(Uri.parse(mediaUrl));

      final storageDir = await Directory(dir).create(recursive: true);

      return await File('${storageDir.path}/$fileName')
          .writeAsBytes(response.bodyBytes);
    } catch (e) {
      return null;
    }
  }
}
