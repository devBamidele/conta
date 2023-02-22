import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  static const tag = '/message_screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          tag,
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
