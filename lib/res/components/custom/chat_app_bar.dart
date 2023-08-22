import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/app_bar_icon.dart';
import 'package:conta/res/components/custom/custom_back_button.dart';
import 'package:conta/res/components/online_status.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:conta/res/components/snackbar_label.dart';
import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../utils/widget_functions.dart';
import '../../../view_model/chat_provider.dart';
import '../confirmation_dialog.dart';
import '../message_counter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
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
                                color: AppColors.hintTextColor,
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
                              style: AppTextStyles.titleMedium,
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

void confirmDelete(BuildContext context, ChatProvider data) {
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
          _showSnackbar(data, context);
        },
      );
    },
  );
}

void _showSnackbar(ChatProvider data, BuildContext context) {
  AppUtils.showSnackbar(
    'Message Deleted',
    delay: const Duration(seconds: 3),
    label: SnackBarLabel(
      onTap: () => data.undoDelete(),
    ),
    onClosed: () => data.clearDeletedMessages(),
  );
}

/*
class SearchAppBarDemo extends StatefulWidget {
  @override
  _SearchAppBarDemoState createState() => _SearchAppBarDemoState();
}

class _SearchAppBarDemoState extends State<SearchAppBarDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isSearchModeActive = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleSearchMode() {
    if (_isSearchModeActive) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isSearchModeActive = !_isSearchModeActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return AppBar(
            title: _isSearchModeActive
                ? Transform.scale(
                    scale: 1.0 - _animation.value, // Transition scale
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  )
                : Text('Chat App'),
            actions: [
              IconButton(
                icon: Icon(_isSearchModeActive
                    ? Icons.close
                    : Icons.search), // Switch icon
                onPressed: _toggleSearchMode,
              ),
            ],
          );
        },
      ),
      body: Center(
        child: Text('Content goes here'),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: SearchAppBarDemo()));

 */
