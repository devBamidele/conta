import 'package:conta/res/components/app_bar_icon.dart';
import 'package:conta/res/components/custom/custom_back_button.dart';
import 'package:conta/res/components/online_status.dart';
import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../utils/widget_functions.dart';
import '../../../view_model/messages_provider.dart';
import '../message_counter.dart';
import '../profile/profile_dialog.dart';
import '../profile_avatar.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ChatAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(58);
}

class _ChatAppBarState extends State<ChatAppBar> {
  final double customSize = 27;

  userDialog(BuildContext context, String? imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ProfileDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (_, data, __) {
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
                  leading: const CustomBackButton(
                    padding: EdgeInsets.only(left: 15),
                    color: AppColors.extraTextColor,
                  ),
                  title: GestureDetector(
                    onTap: () => userDialog(context, currentChat.profilePicUrl),
                    child: Row(
                      children: [
                        ProfileAvatar(imageUrl: currentChat.profilePicUrl),
                        addWidth(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentChat.username,
                                overflow: TextOverflow.fade,
                                style: AppTextStyles.titleMedium,
                              ),
                              addHeight(2),
                              const Status(),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                            onTap: () => data.copyMessageContent().whenComplete(
                                  () => AppUtils.showToast("Message Copied"),
                                ),
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