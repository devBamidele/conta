import 'dart:io';

import 'package:conta/utils/services/local_cache_service.dart';
import 'package:flutter/material.dart';

import '../../../utils/services/storage_manager.dart';
import '../../../utils/widget_functions.dart';
import '../custom_value_color_anim.dart';

class ImageGridTile extends StatelessWidget {
  final String mediaUrl;

  ImageGridTile({
    Key? key,
    required this.mediaUrl,
  }) : super(key: key);

  final dir = StorageManager.storageDirectory!;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: LocalCacheService.checkLocalFile(mediaUrl, dir),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a placeholder while the image is being fetched
          return Center(
            child: CircularProgressIndicator(
              valueColor: customValueColorAnim(),
            ),
          );
        } else if (snapshot.hasError) {
          return errorIcon();
        } else if (snapshot.data == null) {
          // Handle error case or when image couldn't be downloaded
          return Center(
            child: SizedBox(
              height: 70,
              child: Center(
                child: offlineIcon(
                  size: 30,
                  Colors.transparent.withAlpha(120),
                ),
              ),
            ),
          );
        } else {
          // Display the image from the local cache
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              snapshot.data!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => errorIcon(),
            ),
          );
        }
      },
    );
  }
}
