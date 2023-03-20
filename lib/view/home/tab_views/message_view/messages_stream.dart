import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/message.dart';
import '../../../../view_model/chat_messages_provider.dart';
import '../../../../res/color.dart';

class MessagesStream extends StatefulWidget {
  const MessagesStream({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  bool showTail = true;
  bool showDate = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.getChatMessagesStream(
            currentUserUid: data.currentUser!.uid,
            otherUserUid: data.currentChat!.uidUser2,
          ),
          builder: (
            context,
            AsyncSnapshot<List<Message>> snapshot,
          ) {
            if (snapshot.hasData) {
              List<Message> messages = snapshot.data!;
              if (messages.isEmpty) {
                return const Center(
                  child: Text('Empty'),
                );
              }
              return ListView.builder(
                controller: widget.scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Message message = messages[index];
                  bool sameUser = message.senderId == data.currentUser!.uid;
                  if (index < messages.length - 1) {
                    if (message.timestamp
                        .isSameDay(messages[index + 1].timestamp)) {
                      showTail =
                          message.senderId != messages[index + 1].senderId;
                    } else {
                      showTail = true;
                    }
                  } else {
                    // For the very last chat
                    showTail = true;
                  }
                  if (index == 0) {
                    // For the very first chat
                    showDate = true;
                  } else {
                    showDate = !messages[index - 1]
                        .timestamp
                        .isSameDay(message.timestamp);
                  }
                  return Column(
                    children: [
                      Visibility(
                        visible: showDate,
                        child: DateChip(
                          date: message.timestamp.toDate(),
                        ),
                      ),
                      BubbleSpecialThree(
                        text: message.content,
                        color: sameUser ? AppColors.primaryColor : Colors.white,
                        tail: showTail,
                        isSender: sameUser,
                        textStyle: TextStyle(
                          color: sameUser ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Sorry, try again later');
            } else {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: AppColors.primaryShadeColor,
                  size: 50,
                ),
              );
            }
          },
        );
      },
    );
  }
}
