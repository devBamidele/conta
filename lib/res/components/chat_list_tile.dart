import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:conta/res/components/unread_identifier.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../models/chat.dart';
import '../../utils/widget_functions.dart';
import '../color.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key? key,
    required this.tileData,
    required this.isSameUser,
    this.onTileTap,
    required this.oppIndex,
  }) : super(key: key);

  final Chat tileData;
  final bool isSameUser;
  final int oppIndex;
  final VoidCallback? onTileTap;

  @override
  Widget build(BuildContext context) {
    final userIndex = oppIndex == 0 ? 1 : 0;

    return ListTile(
      onTap: onTileTap,
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: _buildProfileImage(userIndex),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildLastMessageTimestamp(),
          addHeight(6),
          isSameUser
              ? messageStatus(tileData.lastMessageStatus)
              : _buildUnreadIdentifier(),
        ],
      ),
      title: _buildUsername(userIndex),
      contentPadding: tileContentPadding,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: _buildLastMessage(),
      ),
    );
  }

  Widget _buildProfileImage(int userIndex) {
    final imageUrl = isSameUser
        ? tileData.profilePicUrls[oppIndex]
        : tileData.profilePicUrls[userIndex];

    return imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl,
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
        : noProfilePic();
  }

  Widget _buildLastMessageTimestamp() {
    return Text(
      tileData.lastMessageTimestamp.customFormat(),
      style: const TextStyle(color: AppColors.extraTextColor),
    );
  }

  Widget _buildUnreadIdentifier() {
    return tileData.unreadCount > 0
        ? UnReadIdentifier(unread: tileData.unreadCount)
        : addHeight(12);
  }

  Widget _buildUsername(int userIndex) {
    return Text(
      isSameUser ? tileData.userNames[oppIndex] : tileData.userNames[userIndex],
      style: const TextStyle(
        fontSize: 18,
        height: 1.2,
      ),
    );
  }

  Widget _buildLastMessage() {
    return Text(
      tileData.lastMessage,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: AppColors.extraTextColor),
    );
  }
}
