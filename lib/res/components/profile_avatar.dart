import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../color.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const ProfileAvatar({
    Key? key,
    this.imageUrl,
    this.radius = 23,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Avatar',
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const ShimmerWidget.circular(
                  width: 46,
                  height: 46,
                ),
                errorWidget: (context, url, error) =>
                    const ShimmerWidget.circular(
                  width: 46,
                  height: 46,
                ),
              )
            : const Icon(
                IconlyBold.profile,
                color: AppColors.hintTextColor,
                size: 25,
              ),
      ),
    );
  }
}
