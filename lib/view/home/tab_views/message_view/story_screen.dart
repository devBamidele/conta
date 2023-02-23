import 'package:flutter/material.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  static const tag = '/story_screen';

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
