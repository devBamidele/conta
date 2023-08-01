import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../color.dart';
import '../custom/custom_back_button.dart';
import '../custom_value_color_anim.dart';

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
      body: SafeArea(
        child: ListView.builder(
          itemCount: media.length,
          itemBuilder: (__, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ImagePreview(path: media[index]),
            );
          },
        ),
      ),
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
      child: Image(
        image: CachedNetworkImageProvider(path),
        loadingBuilder: (context, child, progress) {
          return progress == null
              ? child
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: customValueColorAnim(),
                    value: progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!,
                  ),
                );
        },
        errorBuilder: (context, object, trace) {
          return const Center(
            child: Text('Hello World'),
          );
        },
      ),
    );
  }
}
