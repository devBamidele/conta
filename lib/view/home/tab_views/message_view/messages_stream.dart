import 'dart:developer';

import 'package:conta/res/components/message_bubble.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/message.dart';
import '../../../../res/color.dart';
import '../../../../res/components/date_time/date_chip.dart';
import '../../../../view_model/chat_provider.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser;

  bool showTopSpacing = false;
  bool showTail = true;
  bool showDate = true;

  int messageLimit = 10;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scroll = widget.scrollController;
    // Check if the user has reached the end of the list by scrolling up
    if (scroll.position.atEdge &&
        scroll.position.pixels != 0 &&
        scroll.position.userScrollDirection == ScrollDirection.reverse) {
      // Load the next batch of messages
      setState(() {
        messageLimit += 10;
        log('Loaded Message Count $messageLimit');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.5;
    return Consumer<ChatProvider>(
      builder: (_, data, __) {
        return StreamBuilder(
          stream: data.getChatMessagesStream(
            currentUserUid: currentUser!.uid,
            otherUserUid: data.currentChat!.uidUser2,
            limit: messageLimit,
          ),
          builder: (_, AsyncSnapshot<List<Message>> snapshot) {
            if (snapshot.hasData) {
              List<Message> messages = snapshot.data!;

              if (messages.isEmpty) emptyMessages(size);

              return ListView.builder(
                reverse: true,
                controller: widget.scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final sameUser = message.senderId == currentUser!.uid;

                  showDate = index == messages.length - 1
                      ? true
                      : !messages[index + 1]
                          .timestamp
                          .isSameDay(message.timestamp);

                  showTopSpacing = index == messages.length - 1
                      ? false
                      : !showDate &&
                          message.senderId != messages[index + 1].senderId;

                  showTail = index > 0
                      ? message.timestamp
                              .isSameDay(messages[index - 1].timestamp)
                          ? message.senderId != messages[index - 1].senderId
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
                          timeSent: message.timestamp.customBubbleFormat(),
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
