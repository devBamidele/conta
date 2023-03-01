import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackbar(
    String? text, {
    Duration delay = const Duration(milliseconds: 2000),
  }) {
    if (text == null) return;

    final snackBar = SnackBar(
      duration: delay,
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
      backgroundColor: AppColors.selectedBackgroundColor,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
