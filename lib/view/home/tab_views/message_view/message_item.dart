import 'package:conta/utils/widget_functions.dart';
import 'package:flutter/material.dart';

import '../../../../models/message.dart';
import '../../../../res/components/unread_identifier.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
  }
}
