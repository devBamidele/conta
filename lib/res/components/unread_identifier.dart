import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';

class UnReadIdentifier extends StatelessWidget {
  const UnReadIdentifier({
    Key? key,
    required this.unread,
  }) : super(key: key);

  final num unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.unreadColor,
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
