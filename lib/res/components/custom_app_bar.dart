import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/app_bar_icon.dart';
import 'package:conta/res/components/custom_back_button.dart';
import 'package:conta/res/components/online_status.dart';
import 'package:conta/res/components/shimmer_widget.dart';
import 'package:conta/res/components/snackbar_label.dart';
import 'package:conta/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/chat_messages_provider.dart';
import 'confirmation_dialog.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onCancelPressed;

  const CustomAppBar({
    Key? key,
    this.onCancelPressed,
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
        return GestureDetector(
          onTap: () {
            confirmDelete(context, data);
          },
          child: AppBar(
            leading: data.isMessageLongPressed
                ? AppBarIcon(
                    icon: Icons.close,
                    size: customSize + 2,
                    onTap: () => setState(() => data.resetSelectedMessages()),
                  )
                : CustomBackButton(
                    padding: const EdgeInsets.only(left: 15),
                    color: AppColors.extraTextColor,
                    onPressed: () => data.cancelReply(),
                  ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: data.isMessageLongPressed
                      ? Row(
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
                                  showToast();
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
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            addWidth(10),
                            AppBarIcon(
                                icon: IconlyLight.video, size: customSize),
                            addWidth(20),
                            AppBarIcon(
                                icon: IconlyLight.call, size: customSize),
                          ],
                        ),
                ),
              ),
            ],
            title: data.isMessageLongPressed
                ? const SizedBox.shrink()
                : Row(
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
          ),
        );
      },
    );
  }
}

void showToast() => Fluttertoast.showToast(
      msg: "Message Copied",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );

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
          AppUtils.showSnackbar(
            'Successfully deleted message',
            delay: const Duration(seconds: 3),
            label: SnackBarLabel(onTap: () {}),
          );
        },
      );
    },
  );
}
