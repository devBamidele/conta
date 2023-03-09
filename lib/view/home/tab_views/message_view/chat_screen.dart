import 'dart:math' as math;

import 'package:conta/res/components/custom_app_bar.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';

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

  @override
  void initState() {
    super.initState();

    messagesController.addListener(_updateIcon);
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
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.black,
                              focusNode: messagesFocusNode,
                              controller: messagesController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.backGroundColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                fillColor: fillMessagesColor.withOpacity(0.5),
                                hintText: 'Type Here',
                                contentPadding: const EdgeInsets.all(18),
                                prefixIcon: const Icon(
                                  Icons.attach_file_rounded,
                                  size: 26,
                                  color: AppColors.hintTextColor,
                                ),
                              ),
                            ),
                          ),
                          addWidth(20),
                          CircleAvatar(
                            radius: 26,
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
