import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({Key? key}) : super(key: key);

  static const tag = '/call_screen';

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
