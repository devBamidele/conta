import 'package:flutter/material.dart';

class ImagePreviewItem extends StatelessWidget {
  final String mediaUrl;
  final Size imageSize;

  const ImagePreviewItem({
    Key? key,
    required this.mediaUrl,
    required this.imageSize,
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
