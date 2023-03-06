import 'package:flutter/material.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  static const tag = '/chat_list_view';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        tag,
        style: TextStyle(fontSize: 25),
      ),
    );
  }
}
