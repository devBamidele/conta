import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';

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
              child: ImagePreview(path: media[index]),
            );
          }),
        ),
      );
    } else {
      content = Center(child: ImagePreview(path: media[0]));
    }

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          padding: const EdgeInsets.only(left: 15),
          color: AppColors.extraTextColor,
          onPressed: () => {},
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
            Text(
              timeSent.toStringForSinglePic(),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: content),
    );
  }
}

class ImagePreview extends StatelessWidget {
  final String path;

  const ImagePreview({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: path,
      child: Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }
}
