import 'package:flutter/material.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  static const tag = '/video_screen';

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
