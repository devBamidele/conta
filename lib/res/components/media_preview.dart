import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MediaPreview extends StatelessWidget {
  const MediaPreview({
    Key? key,
    required this.file,
  }) : super(key: key);

  final PlatformFile file;

  @override
  Widget build(BuildContext context) {
    if (file.extension == 'jpg' || file.extension == 'png') {
      return Image.file(File(file.path!));
    } else if (file.extension == 'mp4') {
      // You can use a video player widget here to play videos
      // Example: return VideoPlayerWidget(file.path);
      return Text('Video: ${file.path}');
    } else {
      // Handle other file types accordingly
      return const Text('Unsupported file type');
    }
  }
}
