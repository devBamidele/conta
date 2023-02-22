import 'package:flutter/material.dart';

class UnReadIdentifier extends StatelessWidget {
  const UnReadIdentifier({
    Key? key,
    required this.unread,
  }) : super(key: key);

  final int unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: Text(
        unread.toString(),
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
