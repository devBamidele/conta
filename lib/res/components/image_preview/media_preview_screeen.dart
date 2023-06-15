import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../color.dart';
import '../custom/custom_back_button.dart';

class MediaPreviewScreen extends StatelessWidget {
  final List<String> media;
  final String sender;
  final Timestamp timeSent;

  const MediaPreviewScreen({
    Key? key,
    required this.media,
    required this.sender,
    required this.timeSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (media.length != 1) {
      content = SingleChildScrollView(
        child: Column(
          children: List.generate(media.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ImagePreview(url: media[index]),
            );
          }),
        ),
      );
    } else {
      content = Center(child: ImagePreview(url: media[0]));
    }

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          padding: const EdgeInsets.only(left: 15),
          color: AppColors.extraTextColor,
          onPressed: () => {},
        ),
        title: Row(
          children: [
            Text(sender),
          ],
        ),
      ),
      body: SafeArea(child: content),
    );
  }

  String getFileType(String url) {
    String extension = '';

    int dotIndex = url.lastIndexOf('.');
    if (dotIndex >= 0 && dotIndex < url.length - 1) {
      extension = url.substring(dotIndex + 1).toLowerCase();
    }

    return extension;
  }

  bool isImageFile(String extension) {
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
  }

  bool isPdfFile(String extension) {
    return extension == 'pdf';
  }

  bool isVideoFile(String extension) {
    return ['mp4', 'mov', 'avi'].contains(extension);
  }
}

class ImagePreview extends StatelessWidget {
  final String url;

  const ImagePreview({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(url);
  }
}

class PdfPreview extends StatelessWidget {
  final String url;

  const PdfPreview({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a PDF viewer widget or launch a PDF viewer app
    // Example using url_launcher package:
    return ElevatedButton(
      onPressed: () => launch(url),
      child: const Text('Open PDF'),
    );
  }
}

class VideoPreview extends StatelessWidget {
  final String url;

  const VideoPreview({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a video player widget or launch a video player app
    // Example using url_launcher package:
    return ElevatedButton(
      onPressed: () => launch(url),
      child: const Text('Play Video'),
    );
  }
}
