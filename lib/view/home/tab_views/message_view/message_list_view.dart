import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/message.dart';
import '../../../../view_model/conta_view_model.dart';
import 'message_item.dart';

class MessageListView extends StatelessWidget {
  const MessageListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ContaViewModel>(
      builder: (_, data, Widget? child) {
        return ListView.builder(
          itemCount: data.getMessages().length,
          itemBuilder: (context, index) {
            Message message = data.getMessages()[index];
            return MessageItem(message: message);
          },
        );
      },
    );
  }
}
