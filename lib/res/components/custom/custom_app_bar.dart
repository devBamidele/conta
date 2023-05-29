import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/app_bar_icon.dart';
import 'package:conta/res/components/custom/custom_back_button.dart';
import 'package:conta/res/components/online_status.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:conta/res/components/snackbar_label.dart';
import 'package:conta/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../utils/widget_functions.dart';
import '../../../view_model/chat_messages_provider.dart';
import '../confirmation_dialog.dart';
import '../message_counter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(58);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final double customSize = 27;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        final currentChat = data.currentChat!;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: !data.isMessageLongPressed
              ? AppBar(
                  key: const Key('not-longPressed'),
                  leading: CustomBackButton(
                    padding: const EdgeInsets.only(left: 15),
                    color: AppColors.extraTextColor,
                    onPressed: () => data.cancelReply(),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          addWidth(10),
                          AppBarIcon(icon: IconlyLight.video, size: customSize),
                          addWidth(20),
                          AppBarIcon(icon: IconlyLight.call, size: customSize),
                        ],
                      ),
                    ),
                  ],
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.white,
                        child: currentChat.profilePicUrl != null
                            ? CachedNetworkImage(
                                imageUrl: currentChat.profilePicUrl!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const ShimmerWidget.circular(
                                        width: 46, height: 46),
                                errorWidget: (context, url, error) =>
                                    const ShimmerWidget.circular(
                                        width: 46, height: 46),
                              )
                            : const Icon(
                                IconlyBold.profile,
                                color: Color(0xFF9E9E9E),
                                size: 25,
                              ),
                      ),
                      addWidth(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentChat.username,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 17.5,
                                height: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            addHeight(2),
                            const OnlineStatus(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : AppBar(
                  key: const Key('longPressed'),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: AppBarIcon(
                      icon: Icons.close,
                      size: customSize + 2,
                      onTap: () => setState(
                        () => data.resetSelectedMessages(),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (data.selectedMessages.length == 1)
                            AppBarIcon(
                              icon: Icons.reply_rounded,
                              size: customSize,
                              onTap: () => data.updateReplyByAppBar(),
                            ),
                          addWidth(20),
                          AppBarIcon(
                              icon: Icons.content_copy_outlined,
                              size: customSize - 2,
                              onTap: () {
                                data.copyMessageContent();
                                AppUtils.showToast("Message Copied");
                              }),
                          addWidth(20),
                          AppBarIcon(
                            icon: Icons.reply_rounded,
                            size: customSize,
                            transform: Matrix4.rotationY(math.pi),
                          ),
                          addWidth(20),
                          AppBarIcon(
                            icon: IconlyLight.delete,
                            size: customSize,
                            onTap: () => confirmDelete(context, data),
                          ),
                        ],
                      ),
                    ),
                  ],
                  title: MessageCounter(
                    count: data.selectedMessages.length,
                  ),
                ),
        );
      },
    );
  }
}

void confirmDelete(BuildContext context, ChatMessagesProvider data) {
  final length = data.selectedMessages.length;
  final isSingleMessage = length == 1;
  final contentText = isSingleMessage
      ? 'Are you sure you want to delete this message?'
      : 'Are you sure you want to delete these messages?';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: isSingleMessage ? 'Delete message' : 'Delete $length messages',
        contentText: contentText,
        onConfirmPressed: () {
          data.deleteMessage();
          Navigator.of(context).pop();
          _showSnackbar(data);
        },
      );
    },
  );
}

void _showSnackbar(ChatMessagesProvider data) {
  AppUtils.showSnackbar(
    'Successfully deleted message',
    delay: const Duration(seconds: 3),
    label: SnackBarLabel(
      onTap: () {
        data.undoDelete();
        AppUtils.showToast('Undid selected messages');
      },
    ),
    onClosed: () {
      data.clearDeletedMessages();
      AppUtils.showToast('cleared selected messages');
    },
  );
}
