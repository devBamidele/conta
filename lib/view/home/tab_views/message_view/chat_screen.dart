import 'dart:developer';
import 'dart:math' as math;

import 'package:conta/res/components/chat_text_form_field.dart';
import 'package:conta/res/components/custom_app_bar.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom_fab.dart';
import '../../../../res/components/reply_message.dart';
import 'messages_stream.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const tag = '/chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatMessagesProvider chatProvider;

  final messagesController = TextEditingController();
  final messagesFocusNode = FocusNode();
  final scrollController = ScrollController();

  bool typing = false;
  bool showIcon = false;

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatMessagesProvider>(context, listen: false);
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

    // Remove the status listeners as the page closes
    chatProvider.removeOnlineStatusListener();
    super.dispose();
  }

  _showScrollToBottomIcon() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - scrollController.offset >
          30) {
        setState(() {
          showIcon = true;
        });
      } else {
        setState(() {
          showIcon = false;
        });
      }
    });
  }

  _updateIcon() {
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

  onCancelReply() => chatProvider.cancelReply();

  // Todo : Make the page scroll to the bottom (automatically) and add pagination
  _scrollToBottom() {
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
    chatProvider.uploadChat(messagesController.text);

    setState(() {
      _scrollToBottom();
    });

    onCancelReply();

    messagesController.clear();
  }

  _onPrefixIconTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessagesStream(
                scrollController: scrollController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Consumer<ChatMessagesProvider>(
                          builder: (_, data, Widget? child) {
                            bool isReplying = data.replyChat;
                            return Column(
                              children: [
                                if (isReplying && data.replyMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 1,
                                      right: 1,
                                    ),
                                    child: ReplyMessage(
                                      isYou: data.currentUser!.uid ==
                                          data.replyMessage!.senderId,
                                      message: data.replyMessage!,
                                      senderName: data.currentChat?.username,
                                      onCancelReply: onCancelReply,
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
                      addWidth(8),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.primaryColor,
                        child: typing
                            ? GestureDetector(
                                onTap: _onSendMessageTap,
                                child: Transform.rotate(
                                  angle: math.pi / 4,
                                  child: const Icon(
                                    IconlyBold.send,
                                    size: 23,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                IconlyBold.voice,
                                size: 23,
                                color: Colors.white,
                              ),
                      )
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: -50,
                    child: CustomFAB(
                      showIcon: showIcon,
                      onPressed: _scrollToBottom,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Todo : Incorrect Use of Parent Data Widget -- Reply Message in Message Bubble
// Todo : FAB Scroll to bottom isn't working
