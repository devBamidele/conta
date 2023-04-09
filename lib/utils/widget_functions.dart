import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

Widget addHeight(double height) {
  return SizedBox(height: height);
}

Widget addWidth(double width) {
  return SizedBox(width: width);
}

Widget doubleCheck({double size = 20}) {
  return Icon(
    Icons.done_all_rounded,
    color: Colors.greenAccent,
    size: size,
  );
}

Widget noProfilePic({double size = 25}) {
  return Icon(
    IconlyBold.profile,
    color: const Color(0xFF9E9E9E),
    size: size,
  );
}
