import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../models/search_user.dart';
import '../color.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({
    Key? key,
    required this.user,
    this.onCancelTap,
    this.onTileTap,
  }) : super(key: key);

  final SearchUser user;
  final VoidCallback? onCancelTap;
  final VoidCallback? onTileTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTileTap,
      leading: CircleAvatar(
        radius: 27,
        backgroundColor: Colors.white,
        child: user.profilePicUrl != null
            ? CachedNetworkImage(
                imageUrl: user.profilePicUrl!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const ShimmerWidget.circular(width: 54, height: 54),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : const Icon(
                IconlyBold.profile,
                color: Color(0xFF9E9E9E),
                size: 25,
              ),
      ),
      trailing: IconButton(
        padding: const EdgeInsets.only(left: 20),
        onPressed: onCancelTap,
        icon: const Icon(
          Icons.clear_rounded,
          size: 28,
          color: AppColors.opaqueTextColor,
        ),
      ),
      title: Text(
        user.username,
        style: const TextStyle(
          fontSize: 18,
          height: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          user.name,
          style: const TextStyle(color: AppColors.extraTextColor),
        ),
      ),
    );
  }
}
