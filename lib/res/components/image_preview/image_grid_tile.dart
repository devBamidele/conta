import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/services/storage_manager.dart';
import '../custom_value_color_anim.dart';

class ImageGridTile extends StatelessWidget {
  final String mediaUrl;

  ImageGridTile({
    Key? key,
    required this.mediaUrl,
  }) : super(key: key);

  final dir = StorageManager.storageDirectory!;

  @override
  Widget build(BuildContext context) {
    //
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
