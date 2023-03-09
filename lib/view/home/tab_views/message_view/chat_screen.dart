import 'dart:math' as math;

import 'package:conta/res/components/custom_app_bar.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom_emoji_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const tag = '/chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagesController = TextEditingController();
  final messagesFocusNode = FocusNode();
  Color fillMessagesColor = AppColors.inputBackGround;
  bool typing = false;
  bool emojiShowing = false;

  @override
  void initState() {
    super.initState();

    messagesController.addListener(_updateIcon);

    messagesFocusNode.addListener(() {
      if (messagesFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            emojiShowing = false;
          });
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        //
        // Message currentChat = data.currentChat!;
        return Scaffold(
          appBar: const CustomAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: Container()),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.black,
                              focusNode: messagesFocusNode,
                              controller: messagesController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.backGroundColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.backGroundColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                fillColor: Colors.white,
                                hintText: 'Type Here',
                                contentPadding: const EdgeInsets.all(18),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    messagesFocusNode.unfocus();
                                    messagesFocusNode.canRequestFocus = true;
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      setState(() {
                                        emojiShowing = !emojiShowing;
                                      });
                                    });
                                  },
                                  child: const Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: AppColors.hintTextColor,
                                    size: 28,
                                  ),
                                ),
                                suffixIcon: Transform.rotate(
                                  angle: -math.pi / 1.3,
                                  child: const Icon(
                                    Icons.attach_file_rounded,
                                    size: 28,
                                    color: AppColors.hintTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          addWidth(10),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.primaryColor,
                            child: typing
                                ? Transform.rotate(
                                    angle: math.pi / 4,
                                    child: const Icon(
                                      IconlyBold.send,
                                      size: 23,
                                      color: Colors.white,
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
                      padding: const EdgeInsets.fromLTRB(
                        10,
                        0,
                        10,
                        10,
                      ),
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
      },
    );
  }
}
