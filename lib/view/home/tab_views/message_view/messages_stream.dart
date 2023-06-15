import 'package:conta/res/components/message_bubble.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/message.dart';
import '../../../../res/color.dart';
import '../../../../res/components/date_time/date_chip.dart';
import '../../../../view_model/chat_messages_provider.dart';

/// A widget that displays a stream of chat messages.
class MessagesStream extends StatefulWidget {
  /// Creates a [MessagesStream] widget.
  ///
  /// The [scrollController] is used to control the scrolling behavior of the messages stream.
  const MessagesStream({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  /// The scroll controller for the messages stream.
  final ScrollController scrollController;

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  bool showTail = true;
  bool showDate = true;
  bool showTopSpacing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, __) {
        return StreamBuilder(
          stream: data.getChatMessagesStream(
            currentUserUid: data.currentUser!.uid,
            otherUserUid: data.currentChat!.uidUser2,
          ),
          builder: (_, AsyncSnapshot<List<Message>> snapshot) {
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
                  final message = messages[index];
                  final sameUser = message.senderId == data.currentUser!.uid;

                  showDate = index == 0
                      ? true
                      : !messages[index - 1]
                          .timestamp
                          .isSameDay(message.timestamp);

                  showTopSpacing = index == 0
                      ? false
                      : !showDate &&
                          message.senderId != messages[index - 1].senderId;

                  showTail = index < messages.length - 1
                      ? message.timestamp
                              .isSameDay(messages[index + 1].timestamp)
                          ? message.senderId != messages[index + 1].senderId
                          : true
                      : true;

                  return Column(
                    children: [
                      Visibility(
                        visible: showDate,
                        child: DateChip(
                          date: message.timestamp.toDate(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: showTopSpacing ? 10 : 0),
                        child: MessageBubble(
                          key: Key(message.id),
                          message: message,
                          index: index,
                          color:
                              sameUser ? AppColors.bubbleColor : Colors.white,
                          tail: showTail,
                          isSender: sameUser,
                          timeSent: message.timestamp.customFormat(),
                          textStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15.5,
                          ),
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
