import 'package:flutter/material.dart';

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
        setState(() {
          imageSize =
              Size(info.image.width.toDouble(), info.image.height.toDouble());
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageSize != null) {
      // Calculate the desired width and height based on the image's aspect ratio
      double desiredWidth = imageSize!.width * 0.8;
      double desiredHeight =
          desiredWidth * (imageSize!.height / imageSize!.width);

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
      width: 210,
      height: 400,
      color: Colors.grey,
    );
  }
}
