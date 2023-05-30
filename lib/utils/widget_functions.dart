import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

Widget addHeight(double height) {
  return SizedBox(height: height);
}

Widget addWidth(double width) {
  return SizedBox(width: width);
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

EdgeInsets getBubblePadding(
    bool isSender, bool stateTick, bool hasMedia, bool hasReplyMessage) {
  if (isSender) {
    if (stateTick) {
      if (hasReplyMessage) {
        return const EdgeInsets.fromLTRB(3.5, 3, 13, 7);
      } else if (hasMedia) {
        return const EdgeInsets.fromLTRB(1, 4, 13.5, 7);
      } else {
        return const EdgeInsets.fromLTRB(7, 7, 14, 7);
      }
    } else {
      return const EdgeInsets.fromLTRB(7, 7, 17, 7);
    }
  } else {
    if (hasReplyMessage || hasMedia) {
      return const EdgeInsets.fromLTRB(14, 3, 3, 7);
    } else {
      return const EdgeInsets.fromLTRB(14, 7, 3, 7);
    }
  }
}
