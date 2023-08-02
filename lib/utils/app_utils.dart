import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      elevation: 4,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      behavior: SnackBarBehavior.floating,
      duration: delay,
      content: Row(
        mainAxisAlignment: label == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          label ?? const SizedBox.shrink(),
        ],
      ),
      backgroundColor: AppColors.selectedBackgroundColor,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar).closed.then((_) => onClosed?.call());
  }

  /// Displays a Toast message with the specified [message].
  ///
  /// The Toast message is shown at the bottom of the screen with a short duration.
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }

  /// Shows a centered loading dialog with a staggered dots wave animation.
  ///
  /// The dialog blocks user interaction until it is dismissed.
  static void showLoadingDialog1(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: AppColors.primaryShadeColor,
          size: 55,
        ),
      ),
    );
  }

  static void showLoadingDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: LoadingAnimationWidget.waveDots(
          color: AppColors.primaryShadeColor,
          size: 55,
        ),
      ),
    );
  }
}
