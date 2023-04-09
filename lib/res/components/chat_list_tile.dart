import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/models/chat_tile_data.dart';
import 'package:conta/res/components/unread_identifier.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../utils/widget_functions.dart';
import '../color.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key? key,
    required this.tileData,
    required this.isSameUser,
    this.onTileTap,
  }) : super(key: key);

  final ChatTileData tileData;
  final bool isSameUser;
  final VoidCallback? onTileTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTileTap,
      leading: CircleAvatar(
        radius: 27,
        backgroundColor: Colors.white,
        child: isSameUser
            ? tileData.recipientPicUrl != null
                ? CachedNetworkImage(
                    imageUrl: tileData.recipientPicUrl!,
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : noProfilePic()
            : tileData.senderPicUrl != null
                ? CachedNetworkImage(
                    imageUrl: tileData.senderPicUrl!,
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : noProfilePic(),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            tileData.lastMessageTimestamp.customFormat(),
            style: const TextStyle(color: AppColors.extraTextColor),
          ),
          addHeight(6),
          isSameUser
              ? tileData.senderUnreadMessages > 0
                  ? UnReadIdentifier(
                      unread: tileData.senderUnreadMessages.toInt())
                  : doubleCheck()
              : tileData.recipientUnreadMessages > 0
                  ? UnReadIdentifier(
                      unread: tileData.recipientUnreadMessages.toInt())
                  : doubleCheck()
        ],
      ),
      title: Text(
        isSameUser ? tileData.recipientName : tileData.senderName,
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.extraTextColor),
        ),
      ),
    );
  }
}
