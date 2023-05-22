import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';

/// Utility class for displaying SnackBars using a global key.
class AppUtils {
  /// Global key for accessing the ScaffoldMessengerState to show SnackBars.
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Displays a SnackBar with the specified [text].
  ///
  /// The [delay] parameter controls the duration for which the SnackBar is shown,
  /// and the [label] parameter can be used to add an optional action button.
  /// The [onClosed] callback is invoked when the SnackBar is closed.
  static showSnackbar(
    String? text, {
    Duration delay = const Duration(seconds: 2),
    Widget? label,
    VoidCallback? onClosed,
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
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
          label ?? const SizedBox.shrink(),
        ],
      ),
      backgroundColor: AppColors.dividerColor,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar).closed.then((_) => onClosed?.call());
  }
}
