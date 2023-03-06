import 'package:auto_route/auto_route.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat.dart';
import '../../../../res/color.dart';
import '../../../../res/components/unread_identifier.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Chat message;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        return ListTile(
          onTap: () {
            data.currentChat = message;
            context.router.pushNamed(ChatScreen.tag);
          },
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(message.profilePic),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.lastMessageTime,
                style: const TextStyle(color: AppColors.extraTextColor),
              ),
              addHeight(6),
              message.read
                  ? const Icon(
                      Icons.done_all_rounded,
                      color: Colors.greenAccent,
                      size: 20,
                    )
                  : UnReadIdentifier(
                      unread: message.id!,
                    ),
            ],
          ),
          title: Text(
            message.username,
            style: const TextStyle(
              fontSize: 18,
              height: 1.2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              message.latestMessage,
              style: const TextStyle(color: AppColors.extraTextColor),
            ),
          ),
        );
      },
    );
  }
}
