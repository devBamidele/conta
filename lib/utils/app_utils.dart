import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(
    String? text, {
    Duration delay = const Duration(seconds: 2),
    Widget? label,
  }) {
    if (text == null) return;

    final snackBar = SnackBar(
      duration: delay,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
          label ?? const SizedBox.shrink(),
        ],
      ),
      backgroundColor: AppColors.dividerColor,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
