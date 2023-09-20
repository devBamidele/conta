import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../res/components/confirmation_dialog.dart';
import '../view_model/messages_provider.dart';

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
    String? label,
    VoidCallback? onLabelTapped,
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
          Flexible(
            child: Text(
              text,
              textAlign: label == null ? TextAlign.center : TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox.shrink(),
        ],
      ),
      backgroundColor: AppColors.selectedBackgroundColor,
      action: label != null
          ? SnackBarAction(
              label: label,
              textColor: AppColors.primaryColor,

              // Call the custom label callback
              onPressed: () => onLabelTapped?.call(),
            )
          : null,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar).closed.then((reason) {
        // Check if the snackbar is closed by tapping the label
        if (reason != SnackBarClosedReason.action) {
          onClosed?.call(); // Call the onClosed callback for other reasons
        }
      });
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

void confirmMessageDelete(BuildContext context, MessagesProvider data) {
  final length = data.selectedMessages.length;
  final isSingleMessage = length == 1;
  final contentText = isSingleMessage
      ? 'Are you sure you want to delete this message?'
      : 'Are you sure you want to delete these messages?';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: isSingleMessage ? 'Delete message' : 'Delete $length messages',
        contentText: contentText,
        onConfirmPressed: () {
          data.deleteMessage();
          Navigator.of(context).pop();
          _showSnackbar(data, context);
        },
      );
    },
  );
}

void _showSnackbar(MessagesProvider data, BuildContext context) {
  AppUtils.showSnackbar(
    'Message Deleted',
    delay: const Duration(seconds: 3),
    onLabelTapped: () => data.undoDelete(),
    label: 'UNDO',
    onClosed: () => data.clearDeletedMessages(),
  );
}
