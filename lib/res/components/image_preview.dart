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
  List<Size?> imageSizes = [];
  late double prefWidth;

  @override
  void initState() {
    super.initState();
    loadImageSizes();
  }

  void loadImageSizes() {
    for (var mediaItem in widget.media) {
      Image.network(mediaItem)
          .image
          .resolve(const ImageConfiguration())
          .addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          if (mounted) {
            setState(() {
              imageSizes.add(Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              ));
            });
          }
        }),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // The preferred width of the message bubble
    prefWidth = MediaQuery.of(context).size.width * 0.75;
  }

  @override
  Widget build(BuildContext context) {
    if (imageSizes.isNotEmpty) {
      return Column(
        //
        children: List.generate(widget.media.length, (index) {
          final isLastItem = index == widget.media.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLastItem ? 0 : 6),
            child: ImagePreviewItem(
              mediaUrl: widget.media[index],
              imageSize: imageSizes[index]!,
              prefWidth: prefWidth,
            ),
          );
        }),
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

class ImagePreviewItem extends StatelessWidget {
  final String mediaUrl;
  final Size imageSize;
  final double prefWidth;

  const ImagePreviewItem({
    Key? key,
    required this.mediaUrl,
    required this.imageSize,
    required this.prefWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = 350;

        double desiredWidth = imageSize.width * 0.8;
        double desiredHeight =
            desiredWidth * (imageSize.height / imageSize.width);

        // Check if the desired width exceeds the available width
        if (desiredWidth > maxWidth) {
          desiredWidth = maxWidth;
          desiredHeight = desiredWidth * (imageSize.height / imageSize.width);
        }

        // Check if the desired height exceeds the available height
        if (desiredHeight > maxHeight) {
          desiredHeight = maxHeight;
          desiredWidth = desiredHeight * (imageSize.width / imageSize.height);
        }
//
        return SizedBox(
          width: desiredWidth,
          height: desiredHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              mediaUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
