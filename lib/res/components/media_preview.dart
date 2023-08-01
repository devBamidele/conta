import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../color.dart';

class MediaPreview extends StatelessWidget {
  const MediaPreview({
    Key? key,
    required this.file,
  }) : super(key: key);

  final PlatformFile file;

  @override
  Widget build(BuildContext context) {
    final ext = file.extension?.toLowerCase();

    if (ext == 'jpg' || ext == 'png' || ext == 'jpeg') {
      final imageFile = File(file.path!);

      // Use FutureBuilder to asynchronously load the image
      return FutureBuilder<Uint8List>(
        future: imageFile.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the image to load, show a loading indicator
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.replyMessageColor,
              ),
            );
          } else if (snapshot.hasError) {
            // If an error occurs while loading the image, show an error message
            return Text('Error loading image: ${snapshot.error}');
          } else {
            // If the image is loaded successfully, display it
            return Image.memory(snapshot.data!);
          }
        },
      );
    } else {
      return Center(
        child: Text('File support coming soon : $ext'),
      );
    }
  }
}
//
