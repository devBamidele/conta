import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget addHeight(double height) => SizedBox(height: height);

Widget addWidth(double width) => SizedBox(width: width);

Widget displayLoading(BuildContext context) {
  return Center(
    child: LoadingAnimationWidget.prograssiveDots(
      color: Colors.white,
      size: 50,
    ),
  );
}

Widget doubleTick({double size = 20}) {
  return Icon(
    Icons.done_all_rounded,
    color: Colors.greenAccent,
    size: size,
  );
}

Widget singleTick({double size = 19}) {
  return Icon(
    Icons.check,
    color: Colors.greenAccent,
    size: size,
  );
}

Widget noProfilePic({double size = 27}) {
  return Icon(
    IconlyBold.profile,
    color: AppColors.hintTextColor,
    size: size,
  );
}

Icon errorIcon({double size = 27}) {
  return Icon(
    Icons.error,
    size: size,
  );
}

/// The following icons track the state of the message
Icon sentIcon(Color color) {
  return Icon(
    Icons.done,
    size: 14,
    color: color,
  );
}

Icon offlineIcon(Color color, {double size = 14}) {
  return Icon(
    Icons.wifi_off_rounded,
    size: size,
    color: color,
  );
}

Icon seenIcon(Color color) {
  return Icon(
    Icons.done_all,
    size: 15,
    color: color,
  );
}

Widget replyIcon() {
  return const Icon(
    Icons.reply_rounded,
    size: 30,
    color: AppColors.primaryColor,
  );
}

EdgeInsets getBubblePadding(
  bool isSender,
  bool stateTick,
  bool hasMedia,
  bool hasReplyMessage,
  bool hasContent,
) {
  if (isSender) {
    if (stateTick) {
      if (hasReplyMessage) {
        return const EdgeInsets.fromLTRB(3.5, 3, 13, 7);
      } else if (hasMedia) {
        return EdgeInsets.fromLTRB(1, 4, 14, hasContent ? 8 : 2);
      } else {
        return const EdgeInsets.fromLTRB(7, 7, 14, 7);
      }
    } else {
      return const EdgeInsets.fromLTRB(7, 7, 17, 7);
    }
  } else {
    if (hasReplyMessage) {
      return const EdgeInsets.fromLTRB(14, 3, 3, 7);
    } else if (hasMedia) {
      return EdgeInsets.fromLTRB(9, 3, 3, hasContent ? 8 : 0.5);
    } else {
      return const EdgeInsets.fromLTRB(16, 7, 3, 7);
    }
  }
}

EdgeInsets getContentPadding(
  bool replyMessage,
  bool hasMedia,
) {
  return EdgeInsets.only(
    left: replyMessage || hasMedia ? 8 : 0,
    top: replyMessage || hasMedia ? 3 : 0,
  );
}
