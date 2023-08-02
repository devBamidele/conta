import 'dart:developer';
import 'dart:math' as math;

import 'package:conta/res/components/chat_text_form_field.dart';
import 'package:conta/res/components/custom/custom_app_bar.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:conta/view_model/photo_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom/custom_fab.dart';
import '../../../../res/components/reply_message.dart';
import '../../../../utils/app_router/router.gr.dart';
import '../../../../utils/app_utils.dart';
import 'messages_stream.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const tag = '/chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ChatProvider chatProvider;
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
      duration: const Duration(milliseconds: 300),
    );

    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    photoProvider = Provider.of<PhotoProvider>(context, listen: false);

    messagesController.addListener(_updateIcon);
    _scrollToBottom();
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
      if (scrollController.position.maxScrollExtent - scrollController.offset >
          30) {
        setState(() => showIcon = true);
      } else {
        setState(() => showIcon = false);
      }
    });
  }

  void _updateIcon() {
    if (messagesController.text.isNotEmpty) {
      setState(
        () => typing = true,
      );
    } else {
      setState(
        () => typing = false,
      );
    }
  }

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  // Todo : Make the page scroll to the bottom (automatically) and add pagination
  _scrollToBottom() {
    log('I was clicked');
    // Scroll to the bottom of the list
    SchedulerBinding.instance.addPostFrameCallback((_) {
      log('Well I got executed');
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  // Upload the chat
  // Scroll to the bottom
  // Clear the text field
  _onSendMessageTap() {
    chatProvider.uploadChat(messagesController.text.trim());

    setState(() => _scrollToBottom());

    chatProvider.clearReply();

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
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Column(
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
                      child: CustomFAB(
                        showIcon: showIcon,
                        onPressed: _scrollToBottom,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: chatFieldPadding,
                child: Row(
                  children: [
                    // Text field for chatting
                    Expanded(
                      child: Consumer<ChatProvider>(
                        builder: (_, data, Widget? child) {
                          bool isReplying = data.replyChat;
                          if (isReplying) {
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }
                          return Column(
                            children: [
                              if (isReplying && data.replyMessage != null)
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
                                      senderName: data.currentChat?.username,
                                      onCancelReply: () =>
                                          data.cancelReplyAndClearCache(),
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
                                  ),
                                ),
                              ), //
                            ],
                          );
                        },
                      ),
                    ),

                    // Some horizontal spacing
                    addWidth(8),

                    // Record audio / Send message button
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      child: typing
                          ? GestureDetector(
                              onTap: _onSendMessageTap,
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
        ),
      ),
    );
  }
}
