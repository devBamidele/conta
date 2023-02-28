import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat.dart';
import '../../../../view_model/chat_messages_provider.dart';
import 'message_item.dart';

class MessageListView extends StatelessWidget {
  const MessageListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        return ListView.builder(
          itemCount: data.getMessages().length,
          itemBuilder: (context, index) {
            Chat message = data.getMessages()[index];
            return MessageItem(message: message);
          },
        );
      },
    );
  }
}
