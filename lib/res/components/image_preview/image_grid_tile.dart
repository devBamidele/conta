import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../custom_value_color_anim.dart';

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
      child: CachedNetworkImage(
        imageUrl: mediaUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        // Widget to display in case of loading error
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CircularProgressIndicator(
            valueColor: customValueColorAnim(),
          ),
        ), // Custom progress indicator
      ),
    );
  }
}
/*

Future<void> uploadImagesAndResize(BuildContext context) async {
    // Display circular progress indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text('Uploading and resizing images...'),
            ],
          ),
        ),
      ),
    );

    try {
      final updatedMediaUrls = <String?>[];

      for (String? url in message.media!) {
        if (url != null && !url.startsWith('http')) {
          final resizedUrl = await uploadAndResizeImage(url);
          updatedMediaUrls.add(resizedUrl);
        } else {
          updatedMediaUrls.add(url);
        }
      }

      // Update the message with the updated media URLs
      message.media = updatedMediaUrls;

      // Update the message in Firestore

      // Close the progress indicator dialog
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors during image upload and resizing

      // Close the progress indicator dialog
      Navigator.pop(context);
    }
  }

  Future<String> uploadAndResizeImage(String filePath) async {
    // Upload the image to storage and resize it
    // Wait for the extension to resize the image and retrieve the download URL

    return resizedImageUrl; // The resized image's download URL
  }

 */
