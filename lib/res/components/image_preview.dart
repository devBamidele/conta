import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../color.dart';

class ImagePreview extends StatefulWidget {
  final List<String> media;

  const ImagePreview({
    Key? key,
    required this.media,
  }) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Size? imageSize;
  late double prefWidth;

  @override
  void initState() {
    super.initState();
    loadImageSize();
  }

  void loadImageSize() {
    Image.network(widget.media[0])
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // The preferred width of the message bubble
    prefWidth = MediaQuery.of(context).size.width * .75;
  }

  @override
  Widget build(BuildContext context) {
    if (imageSize != null) {
      // Calculate the desired width and height based on the image's aspect ratio
      double desiredWidth = imageSize!.width * 0.9;
      double desiredHeight =
          desiredWidth * (imageSize!.height / imageSize!.width);

      // Set a maximum height for large images
      double maxHeight = 400;

      // Check if the desired height exceeds the maximum height
      if (desiredHeight > maxHeight) {
        desiredHeight = maxHeight;
        desiredWidth = desiredHeight * (imageSize!.width / imageSize!.height);
      }

      if (desiredWidth < prefWidth) {}

      return SizedBox(
        width: desiredWidth,
        height: desiredHeight,
        child: Image.network(
          widget.media[0],
          fit: BoxFit.cover,
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
