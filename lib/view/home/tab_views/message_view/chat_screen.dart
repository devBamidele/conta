import 'dart:math' as math;

import 'package:conta/res/components/chat_text_form_field.dart';
import 'package:conta/res/components/custom_app_bar.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom_emoji_picker.dart';
import 'messages_stream.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const tag = '/chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagesController = TextEditingController();
  final messagesFocusNode = FocusNode();
  final scrollController = ScrollController();

  bool typing = false;
  bool emojiShowing = false;

  @override
  void initState() {
    super.initState();

    messagesController.addListener(_updateIcon);

    messagesFocusNode.addListener(_removeEmojiPicker);

    _scrollToBottom();
  }

  @override
  void dispose() {
    messagesFocusNode.dispose();
    messagesController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  _removeEmojiPicker() {
    if (messagesFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {
          emojiShowing = false;
        });
      });
    }
  }

  _updateIcon() {
    if (messagesController.text.isNotEmpty) {
      setState(() {
        typing = true;
      });
    } else {
      setState(() {
        typing = false;
      });
    }
  }

  _scrollToBottom() {
    // Scroll to the bottom of the list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });
  }

  _onSendMessageTap() {
    final chatProvider =
        Provider.of<ChatMessagesProvider>(context, listen: false);

    chatProvider.uploadChat(messagesController.text);

    _scrollToBottom();
    messagesController.clear();
  }

  _onSuffixIconTap() {}

  // Execute this function when the prefix icon button is tapped
  _onPrefixIconTap() {
    messagesFocusNode.unfocus();
    messagesFocusNode.canRequestFocus = true;
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        emojiShowing = !emojiShowing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MessagesStream(
                  scrollController: scrollController,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ChatTextFormField(
                          node: messagesFocusNode,
                          controller: messagesController,
                          onPrefixIconTap: _onPrefixIconTap,
                          onSuffixIconTap: _onSuffixIconTap,
                        ),
                      ),
                      addWidth(10),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Offstage(
                    offstage: !emojiShowing,
                    child: SizedBox(
                      height: 250,
                      child: CustomEmojiPicker(
                        messagesController: messagesController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
