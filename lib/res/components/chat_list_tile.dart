import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:conta/res/components/unread_identifier.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import '../../utils/app_utils.dart';
import '../../utils/widget_functions.dart';
import '../color.dart';

class ChatListTile extends StatefulWidget {
  const ChatListTile({
    Key? key,
    required this.tileData,
    required this.isSameUser,
    this.onTileTap,
    required this.oppIndex,
    required this.samePerson,
  }) : super(key: key);

  final Chat tileData;
  final bool isSameUser;
  final int oppIndex;
  final VoidCallback? onTileTap;
  final bool samePerson;

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  bool chatMuted = false;

  @override
  void initState() {
    super.initState();
    chatMuted = widget.tileData.userMuted[widget.oppIndex];
  }

  Future<void> onActionPressed(ChatProvider data) async {
    Future.delayed(const Duration(milliseconds: 100), () {
      final name = widget.tileData.userNames[widget.oppIndex];

      setState(() {
        chatMuted = !chatMuted;
      });

      AppUtils.showToast(
          '${chatMuted ? 'muted' : 'Un-muted'} notifications from $name');

      data.toggleMutedStatus(
        chatId: widget.tileData.id!,
        index: widget.oppIndex,
        newValue: chatMuted,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, data, Widget? child) {
        return Slidable(
          endActionPane: widget.samePerson
              ? null
              : ActionPane(
                  extentRatio: 0.25,
                  motion: const BehindMotion(),
                  children: [
                    CustomSlidableAction(
                      backgroundColor: Colors.transparent,
                      onPressed: (context) => onActionPressed(data),
                      child: MuteButton(chatMuted: chatMuted),
                    ),
                  ],
                ),
          child: ListTile(
            onTap: widget.onTileTap,
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: _buildProfileImage(),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildLastMessageTimestamp(),
                addHeight(10),
                widget.isSameUser
                    ? messageStatus(widget.tileData.lastMessageStatus)
                    : _buildUnreadIdentifier(),
              ],
            ),
            title: _buildUsername(),
            contentPadding: tileContentPadding,
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: _buildLastMessage(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    final imageUrl = widget.tileData.profilePicUrls[widget.oppIndex];

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
      widget.tileData.lastMessageTimestamp.customTileFormat(),
      style: const TextStyle(color: AppColors.extraTextColor),
    );
  }

  Widget _buildUnreadIdentifier() {
    return widget.tileData.unreadCount > 0
        ? UnReadIdentifier(unread: widget.tileData.unreadCount)
        : addHeight(12);
  }

  Widget _buildUsername() {
    return Row(
      children: [
        Row(
          children: [
            Text(
              widget.tileData.userNames[widget.oppIndex],
              style: const TextStyle(
                  fontSize: 18, height: 1.2, color: AppColors.blackColor),
            ),
            addWidth(2),
            Text(
              widget.samePerson ? '(You)' : '',
              style: const TextStyle(fontSize: 16, color: AppColors.blackColor),
            ),
          ],
        ),
        Visibility(
          visible: chatMuted,
          child: const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(
              IconlyLight.volume_off,
              size: 14,
              color: AppColors.blackColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastMessage() {
    return Text(
      widget.tileData.lastMessage,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: AppColors.extraTextColor),
    );
  }
}

class MuteButton extends StatelessWidget {
  final bool chatMuted;

  const MuteButton({required this.chatMuted, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: chatMuted
            ? AppColors.custom
            : AppColors.opaqueTextColor.withOpacity(0.25),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            chatMuted ? IconlyLight.volume_up : IconlyLight.volume_off,
            color: chatMuted
                ? AppColors.primaryShadeColor.withOpacity(0.8)
                : AppColors.continueWithColor.withOpacity(0.8),
            size: 22,
          ),
          addHeight(2),
          Text(
            chatMuted ? 'Un-mute' : 'Mute',
            style: TextStyle(
              color: chatMuted
                  ? AppColors.primaryShadeColor.withOpacity(0.8)
                  : AppColors.continueWithColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
