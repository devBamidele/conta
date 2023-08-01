import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_router/router.dart';
import '../custom/custom_value_color_anim.dart';

/// A widget that displays an image with dynamic sizing based on the available space.
///
/// The [SingleImageTile] widget takes an [mediaUrl] as the image URL.
/// It calculates the desired width and height of the image based on the available constraints and scales the image accordingly.
///
/// If the calculated dimensions exceed the available width or height, the image is scaled down while maintaining the aspect ratio.
/// The scaled image is then displayed within a [SizedBox] with rounded corners using [ClipRRect].
///
class SingleImageTile extends StatelessWidget {
  final String mediaUrl;
  final String sender;
  final Timestamp timeSent;

  const SingleImageTile({
    Key? key,
    required this.mediaUrl,
    required this.sender,
    required this.timeSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth * 0.8,
            maxHeight: 350,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onTap: () => goToMediaPreview(context),
              child: Hero(
                tag: mediaUrl,
                child: CachedNetworkImage(
                  imageUrl: mediaUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      valueColor: customValueColorAnim(),
                      value: downloadProgress.progress,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void goToMediaPreview(BuildContext context) => navPush(
        context,
        ViewImageScreenRoute(
          media: [mediaUrl],
          sender: sender,
          timeSent: timeSent,
        ),
      );
}
