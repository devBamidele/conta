import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:conta/res/components/app_bars/chat_app_bar.dart';
import 'package:conta/res/components/chat_text_form_field.dart';
import 'package:conta/res/components/confirmation_dialog.dart';
import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:conta/view_model/messages_provider.dart';
import 'package:conta/view_model/photo_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom/custom_scroll_button.dart';
import '../../../../res/components/reply_message.dart';
import '../../../../utils/app_router/router.gr.dart';
import '../../../../utils/app_utils.dart';
import 'messages_stream.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late MessagesProvider chatProvider;
  late PhotoProvider photoProvider;

  final messagesController = TextEditingController();
  final messagesFocusNode = FocusNode();
  final scrollController = ScrollController();
  final currentUser = FirebaseAuth.instance.currentUser;

  bool typing = false;
  bool showIcon = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    chatProvider = Provider.of<MessagesProvider>(context, listen: false);
    photoProvider = Provider.of<PhotoProvider>(context, listen: false);

    messagesController.addListener(_updateIcon);
    _showScrollToBottomIcon();
  }

  @override
  void dispose() {
    // Dispose the controllers and nodes
    messagesFocusNode.dispose();
    messagesController.dispose();
    scrollController.dispose();

    _controller.dispose();
    super.dispose();
  }

  void _showScrollToBottomIcon() {
    scrollController.addListener(() {
      if (scrollController.offset > 30) {
        setState(() => showIcon = true);
      } else {
        setState(() => showIcon = false);
      }
    });
  }

  void _updateIcon() {
    if (messagesController.text.isNotEmpty) {
      setState(() => typing = true);
    } else {
      setState(() => typing = false);
    }
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController
            .animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn)
            .then((value) {
          if (scrollController.offset > 20) {
            // If not close to the bottom, trigger the function
            _scrollToBottom();
          }
        });
      }
    });
  }

  void sendMessage(String message) {
    _scrollToBottom();

    chatProvider.uploadChat(message);

    messagesController.clear();
  }

  void _onPrefixIconTap() async {
    photoProvider.getImages(
      onPick: navigateToPreview,
      showToast: showToast,
    );
  }

  void showToast(String message) {
    if (mounted) {
      AppUtils.showToast(message);
    }
  }

  void navigateToPreview() => navPush(context, const PreviewScreenRoute());

  Future<bool> onWillPop() async {
    chatProvider.cancelReplyAndClearCache();

    chatProvider.clearIdData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Consumer2<MessagesProvider, ChatProvider>(
        builder: (_, data, chat, Widget? child) {
          bool isReplying = data.replyChat;

          final currentChat = data.currentChat!;

          if (isReplying) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          return Scaffold(
            appBar: const ChatAppBar(),
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/extras/wallpaper.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            MessagesStream(
                              scrollController: scrollController,
                            ),
                            Positioned(
                              bottom: 10,
                              right: 20,
                              child: CustomScrollButton(
                                showIcon: showIcon,
                                onPressed: _scrollToBottom,
                              ),
                            )
                          ],
                        ),
                      ),
                      currentChat.isDeleted ?? false
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: GestureDetector(
                                onTap: () =>
                                    confirmChatDelete(context, data, chat),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 44,
                                  color: Colors.white,
                                  child: const Text(
                                    'Delete Chat',
                                    style: AppTextStyles.deleteChatText,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: chatFieldPadding,
                              child: Row(
                                children: [
                                  // Text field for chatting

                                  Expanded(
                                    child: Column(
                                      children: [
                                        if (isReplying &&
                                            data.replyMessage != null)
                                          SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0, 1),
                                              end: Offset.zero,
                                            ).animate(_controller),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 1,
                                                right: 1,
                                              ),
                                              child: ReplyMessage(
                                                isYou: currentUser!.uid ==
                                                    data.replyMessage!.senderId,
                                                message: data.replyMessage!,
                                                senderName:
                                                    data.currentChat?.username,
                                                onCancelReply: () => data
                                                    .cancelReplyAndClearCache(),
                                              ),
                                            ),
                                          ),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 5 * 16 * 1.4,
                                          ),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            reverse: true,
                                            child: ChatTextFormField(
                                              node: messagesFocusNode,
                                              controller: messagesController,
                                              onPrefixIconTap: _onPrefixIconTap,
                                              isReplying: isReplying,
                                              onFieldSubmitted: sendMessage,
                                            ),
                                          ),
                                        ), //
                                      ],
                                    ),
                                  ),

                                  // Some horizontal spacing
                                  addWidth(8),

                                  // Record audio / Send message button
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: AppColors.primaryColor,
                                    child: typing
                                        ? GestureDetector(
                                            onTap: () => sendMessage(
                                                messagesController.text.trim()),
                                            child: Transform.rotate(
                                              angle: math.pi / 4,
                                              child: sendIcon(),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () => AppUtils.showToast(
                                                'That feature is not yet available'),
                                            child: voiceIcon(),
                                          ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void confirmChatDelete(
    BuildContext context, MessagesProvider data, ChatProvider chat) {
  final name = data.currentChat!.username;
  final chatId = data.currentChat!.chatId!;

  final contentWidget = RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.8),
        letterSpacing: 0.2,
      ),
      children: [
        const TextSpan(
          text: 'Permanently delete the chat with ',
          style: TextStyle(),
        ),
        TextSpan(
          text: name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: 'Delete chat',
        contentWidget: contentWidget,
        onConfirmPressed: () {
          chat.toggleChatDeletionStatus(chatId, true);

          // a simplified version of the above line
          context.router.popUntilRouteWithName('HomeScreenRoute');

          // Display a message
          _showSnackbar(chat, context, name, chatId);
        },
      );
    },
  );
}

void _showSnackbar(
  ChatProvider chat,
  BuildContext context,
  String name,
  String chatId,
) {
  AppUtils.showSnackbar(
    'Chat with $name deleted',
    delay: const Duration(seconds: 5),
    label: 'UNDO',
    onLabelTapped: () => chat.toggleChatDeletionStatus(chatId, false),
    onClosed: () => chat.confirmDeleteChat(chatId),
  );
}
