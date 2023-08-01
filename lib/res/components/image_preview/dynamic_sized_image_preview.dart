import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/app_router/router.dart';
import '../../color.dart';
import '../custom_value_color_anim.dart';

/// A widget that displays an image with dynamic sizing based on the available space.
///
/// The [DynamicSizedImagePreview] widget takes an [mediaUrl] as the image URL.
/// It calculates the desired width and height of the image based on the available constraints and scales the image accordingly.
///
/// If the calculated dimensions exceed the available width or height, the image is scaled down while maintaining the aspect ratio.
/// The scaled image is then displayed within a [SizedBox] with rounded corners using [ClipRRect].

class DynamicSizedImagePreview extends StatefulWidget {
  /// The URL of the image to be displayed.
  final String mediaUrl;
  final String sender;
  final Timestamp timeSent;

  /// Creates a [DynamicSizedImagePreview] widget.
  ///
  /// The [mediaUrl] parameter is required.
  const DynamicSizedImagePreview({
    Key? key,
    required this.mediaUrl,
    required this.sender,
    required this.timeSent,
  }) : super(key: key);

  @override
  State<DynamicSizedImagePreview> createState() =>
      _DynamicSizedImagePreviewState();
}

class _DynamicSizedImagePreviewState extends State<DynamicSizedImagePreview> {
  late String storageDirectory;

  Size? imageSize;
  bool networkError = false;
  late double size;

  @override
  void initState() {
    super.initState();

    loadImageSize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // The preferred width of the message bubble
    size = MediaQuery.of(context).size.width * .25;
  }

  void loadImageSize() {
    Image.network(widget.mediaUrl)
        .image
        .resolve(const ImageConfiguration())
        .addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        if (mounted) {
          setState(() {
            imageSize = Size(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            );
          });
        }
      }),
    );
  }

  void goToMediaPreview(BuildContext context) => navPush(
        context,
        MediaPreviewScreenRoute(
          media: [widget.mediaUrl],
          sender: widget.sender,
          timeSent: widget.timeSent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (imageSize != null) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double maxWidth = constraints.maxWidth;
          double maxHeight = 350;

          double desiredWidth = imageSize!.width * 0.8;
          double desiredHeight =
              desiredWidth * (imageSize!.height / imageSize!.width);

          // Check if the desired width exceeds the available width
          if (desiredWidth > maxWidth) {
            desiredWidth = maxWidth;
            desiredHeight =
                desiredWidth * (imageSize!.height / imageSize!.width);
          }

          // Check if the desired height exceeds the available height
          if (desiredHeight > maxHeight) {
            desiredHeight = maxHeight;
            desiredWidth =
                desiredHeight * (imageSize!.width / imageSize!.height);
          }

          return SizedBox(
            width: desiredWidth,
            height: desiredHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () => goToMediaPreview(context),
                child: Hero(
                  tag: widget.mediaUrl,
                  child: CachedNetworkImage(
                    imageUrl: widget.mediaUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
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
    if (networkError) {
      return SizedBox(
        height: 70,
        child: Center(
          child: offlineIcon(
            size: 30,
            Colors.transparent.withAlpha(120),
          ),
        ),
      );
    }

    // Placeholder widget while the image dimensions are being fetched
    return Container(
      height: size,
      width: size,
      color: Colors.transparent,
      child: Center(
        child: LoadingAnimationWidget.discreteCircle(
          size: 30,
          color: AppColors.mainRingColor,
          secondRingColor: AppColors.secondRingColor,
          thirdRingColor: AppColors.thirdRingColor,
        ),
      ),
    );
  }
}
