import 'dart:async';
import 'dart:developer';
import 'dart:io' show Directory, File;

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/services/storage_manager.dart';
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
  String? localImagePath;
  late String storageDirectory;
  late String fileName;

  Size? imageSize;
  bool networkError = false;

  @override
  void initState() {
    super.initState();

    fileName = widget.mediaUrl.getFileName();

    storageDirectory = StorageManager.storageDirectory!;

    _checkLocalFile().then((value) => loadImageSize());
  }

  Future<void> _checkLocalFile() async {
    final storageDir = Directory(storageDirectory);
    final localFile = File('${storageDir.path}/$fileName');

    if (await localFile.exists()) {
      setState(() {
        localImagePath = localFile.path;
        log('The file exists locally at $localImagePath');
      });
    } else {
      await _downloadAndSaveImage();
    }
  }

  Future<void> _downloadAndSaveImage() async {
    final response = await http.get(Uri.parse(widget.mediaUrl));

    final storageDir =
        await Directory(storageDirectory).create(recursive: true);

    final localFile = await File('${storageDir.path}/$fileName')
        .writeAsBytes(response.bodyBytes);

    setState(() {
      localImagePath = localFile.path;
      log('Successfully downloaded and saved at $localImagePath');
    });
  }

  void loadImageSize() {
    if (localImagePath == null) {
      log('The local image path is currently null');
    } else {
      log('The local image path is: $localImagePath');
      Image.file(File(localImagePath!))
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
  }

  void goToMediaPreview(BuildContext context) => context.router.push(
        MediaPreviewScreenRoute(
          media: [localImagePath!],
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
              child: localImagePath != null
                  ? GestureDetector(
                      onTap: () => goToMediaPreview(context),
                      child: Hero(
                        tag: localImagePath!,
                        child: Image.file(
                          File(localImagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: customValueColorAnim(),
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
