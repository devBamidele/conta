import 'package:flutter/material.dart';

/// A widget that represents a tile within an image grid.
///
/// The [ImageGridTile] widget is used to display an image preview within a grid layout,
/// such as a grid view or a grid-like container. It applies a circular border radius
/// to the image and ensures the image covers the available space within the tile.
///
/// The [mediaUrl] parameter is required and specifies the URL of the image to be displayed.
///
/// Example usage:
///
/// ```dart
/// ImageGridTile(
///   mediaUrl: 'https://example.com/image.jpg',
/// )
/// ```
class ImageGridTile extends StatelessWidget {
  /// The URL of the image to be displayed within the tile.
  final String mediaUrl;

  /// Creates an [ImageGridTile].
  ///
  /// The [mediaUrl] parameter is required.
  const ImageGridTile({
    Key? key,
    required this.mediaUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        mediaUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
