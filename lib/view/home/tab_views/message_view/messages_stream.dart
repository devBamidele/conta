import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/message.dart';
import '../../../../view_model/chat_messages_provider.dart';
import '../../../../res/color.dart';
import '../../../../res/components/message_bubble.dart';

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

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
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Message message = messages[index];

                  return MessageBubble(
                    text: message.content,
                    isMe: message.senderId == data.currentUser!.uid,
                    timeSent: message.timestamp,
                    unread: message.isUnread,
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
