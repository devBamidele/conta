import 'dart:async';
import 'dart:io' show SocketException;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

  /// Creates a [DynamicSizedImagePreview] widget.
  ///
  /// The [mediaUrl] parameter is required.
  const DynamicSizedImagePreview({
    Key? key,
    required this.mediaUrl,
  }) : super(key: key);

  @override
  State<DynamicSizedImagePreview> createState() =>
      _DynamicSizedImagePreviewState();
}

class _DynamicSizedImagePreviewState extends State<DynamicSizedImagePreview> {
  Size? imageSize;
  bool networkError = false;

  @override
  void initState() {
    super.initState();
    loadImageSize();
  }

  void loadImageSize() {
    final completer = Completer<void>();

    try {
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
          completer.complete();
        }),
      );

      Future.delayed(const Duration(seconds: 10)).then((_) {
        if (!completer.isCompleted) {
          // Timeout occurred
          if (mounted) {
            setState(() {
              networkError = true;
            });
          }
          completer.completeError('Image load timed out');
        }
      });
    } catch (error) {
      if (error is PlatformException && error.code == 'network_error') {
        // No internet connection, stop trying to download the image
        if (mounted) {
          setState(() {
            networkError = true;
          });
        }
      } else if (error is SocketException) {
        // SocketException occurred, handle it accordingly
        if (mounted) {
          setState(() {
            networkError = true;
          });
        }
      } else {
        networkError = true;
      }
    }
  }

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
              child: CachedNetworkImage(
                imageUrl: widget.mediaUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                // Widget to display in case of loading error
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    valueColor: customValueColorAnim(),
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
          child: Icon(
            Icons.wifi_off_rounded,
            size: 30,
            color: Colors.transparent.withAlpha(120),
          ),
        ),
      );
    }

    // Placeholder widget while the image dimensions are being fetched
    return Container(
      height: 90,
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
