import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
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
import '../profile_avatar.dart';
import '../shimmer/shimmer_widget.dart';

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
                              const OnlineStatus(),
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

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (_, data, __) {
        String? imageUrl = data.currentChat!.profilePicUrl;
        return Dialog(
          clipBehavior: Clip.hardEdge,
          child: Container(
            color: Colors.white,
            height: 450,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    imageUrl != null
                        ? SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const ShimmerWidget.circular(
                                    width: 46,
                                    height: 46,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const ShimmerWidget.circular(
                                    width: 46,
                                    height: 46,
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(18, 0, 0, 18),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Demilade',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const Icon(
                            IconlyBold.profile,
                            color: AppColors.hintTextColor,
                            size: 25,
                          ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 0, 0),
                      child: Column(
                        children: [
                          const Text(
                            'Info',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryShadeColor,
                              fontSize: 16,
                            ),
                          ),
                          ListTile(
                            title: const Text('Bio'),
                            titleTextStyle: TextStyle(
                              fontSize: 13,
                              color: AppColors.blackColor.withOpacity(0.7),
                            ),
                            subtitle: const Text('Bio'),
                            subtitleTextStyle: const TextStyle(
                              fontSize: 16,
                              color: AppColors.blackColor,
                            ),
                          ),
                          addHeight(4),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox.square(
                      dimension: 50,
                      child: FloatingActionButton(
                        elevation: 2,
                        backgroundColor: Colors.white,
                        onPressed: () {},
                        shape: const CircleBorder(),
                        child: const Icon(
                          IconlyLight.chat,
                          size: 28,
                          color: AppColors.extraTextColor,
                        ),
                      ),
                    ),
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
