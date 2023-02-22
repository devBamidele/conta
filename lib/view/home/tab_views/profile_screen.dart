import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const tag = '/profile_screen';

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
