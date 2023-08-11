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
  }) : super(key: key);

  final Chat tileData;
  final bool isSameUser;
  final int oppIndex;
  final VoidCallback? onTileTap;

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  bool chatMuted = false;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    chatMuted = widget.tileData.userMuted[widget.oppIndex];
  }

  Future<void> onActionPressed(ChatProvider data) async {
    final name = widget.tileData.userNames[widget.oppIndex];

    setState(() {
      chatMuted = !chatMuted;
      waiting = true;
    });

    AppUtils.showToast(
        'Successfully ${chatMuted ? 'muted' : 'Un-muted'} $name');

    // Delay execution for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          waiting = false;
        });

        // Call toggleMutedStatus only if we're done waiting
        if (!waiting) {
          data.toggleMutedStatus(
            chatId: widget.tileData.id!,
            index: widget.oppIndex,
            newValue: chatMuted,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, data, Widget? child) {
        return Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.28,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => onActionPressed(data),
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: chatMuted ? IconlyBold.volume_up : IconlyBold.volume_off,
                label: chatMuted ? 'Un-mute' : 'Mute',
              ),
            ],
          ),
          child: ListTile(
            onTap: widget.onTileTap,
            leading: CircleAvatar(
              radius: 25,
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
      widget.tileData.lastMessageTimestamp.customFormat(),
      style: const TextStyle(color: AppColors.extraTextColor),
    );
  }

  Widget _buildUnreadIdentifier() {
    return widget.tileData.unreadCount > 0
        ? UnReadIdentifier(unread: widget.tileData.unreadCount)
        : addHeight(12);
  }

  Widget _buildUsername() {
    return Text(
      widget.tileData.userNames[widget.oppIndex],
      style: const TextStyle(
        fontSize: 18,
        height: 1.2,
      ),
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
