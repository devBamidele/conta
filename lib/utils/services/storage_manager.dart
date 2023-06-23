import 'dart:developer';

import 'package:path_provider/path_provider.dart';

class StorageManager {
  static String? _storageDirectory;

  static String? get storageDirectory => _storageDirectory;

  static Future<void> initialize() async {
    _storageDirectory = await _getStorageDirectory();
    log('The Storage directory is $storageDirectory');
  }

  static Future<String> _getStorageDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
