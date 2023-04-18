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
