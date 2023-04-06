import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/models/chat_tile_data.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../utils/widget_functions.dart';
import '../color.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key? key,
    required this.tileData,
    this.onCancelTap,
    this.onTileTap,
  }) : super(key: key);

  final ChatTileData tileData;
  final VoidCallback? onCancelTap;
  final VoidCallback? onTileTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTileTap,
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: tileData.profilePicUrl != null
            ? CachedNetworkImage(
                imageUrl: tileData.profilePicUrl!,
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
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : const Icon(
                IconlyBold.profile,
                color: Color(0xFF9E9E9E),
                size: 25,
              ),
      ),
      trailing: onCancelTap != null
          ? IconButton(
              padding: const EdgeInsets.only(left: 20),
              onPressed: onCancelTap,
              icon: const Icon(
                Icons.clear_rounded,
                size: 28,
                color: AppColors.opaqueTextColor,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tileData.lastMessageTimestamp.customFormat(),
                  style: const TextStyle(color: AppColors.extraTextColor),
                ),
                addHeight(6),
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.greenAccent,
                  size: 20,
                )
              ],
            ),
      title: Text(
        tileData.userName,
        style: const TextStyle(
          fontSize: 18,
          height: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          tileData.lastMessage,
          style: const TextStyle(color: AppColors.extraTextColor),
        ),
      ),
    );
  }
}
