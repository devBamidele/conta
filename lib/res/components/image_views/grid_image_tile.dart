import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../custom/custom_value_color_anim.dart';

class GridImageTile extends StatelessWidget {
  final String mediaUrl;

  const GridImageTile({
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
