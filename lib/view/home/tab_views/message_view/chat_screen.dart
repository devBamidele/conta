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

  // Todo : Make the page scroll to the bottom (automatically) and add pagination
  _scrollToBottom() =>
      // Scroll to the bottom of the list
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
          );
        } //
      });

  // Upload the chat
  // Scroll to the bottom
  // Clear the text field
  _onSendMessageTap() {
    chatProvider.uploadChat(messagesController.text);

    setState(_scrollToBottom());

    messagesController.clear();
  }

  _onPrefixIconTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFAB(
        showIcon: showIcon,
        onPressed: _scrollToBottom,
      ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ConstrainedBox(
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
                        ),
                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}
