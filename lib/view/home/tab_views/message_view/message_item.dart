import 'package:auto_route/auto_route.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';
import 'package:conta/view_model/conta_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat.dart';
import '../../../../res/components/unread_identifier.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Chat message;

  @override
  Widget build(BuildContext context) {
    return Consumer<ContaViewModel>(builder: (_, data, Widget? child) {
      return ListTile(
        onTap: () {
          data.currentChat = message;
          context.router.pushNamed(ChatScreen.tag);
        },
        leading: CircleAvatar(
          radius: 23,
          backgroundImage: AssetImage(message.profilePic),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.timeStamp),
            addHeight(4),
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
          message.sender,
        ),
        subtitle: Text(message.message),
      );
    });
  }
}
