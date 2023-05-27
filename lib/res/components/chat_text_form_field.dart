import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../color.dart';
import '../style/component_style.dart';

class ChatTextFormField extends StatelessWidget {
  const ChatTextFormField({
    Key? key,
    required this.node,
    required this.controller,
    this.onPrefixIconTap,
    this.isReplying = false,
    this.prefixIcon = Icons.attach_file_rounded,
    this.prefixIconSize = 28,
    this.rotationalAngle = -math.pi / 1.3,
    this.hintText = 'Message',
  }) : super(key: key);

  final FocusNode node;
  final TextEditingController controller;
  final VoidCallback? onPrefixIconTap;
  final IconData prefixIcon;
  final double prefixIconSize;
  final double rotationalAngle;
  final bool isReplying;
  final String hintText;

  final double curve = 22;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 16, // Also change the value in the constrains on this widget
        height: 1.4,
        letterSpacing: 0.2,
      ),
      maxLines: null,
      cursorColor: Colors.black,
      focusNode: node,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: customBorder(isReplying: isReplying),
        focusedBorder: customBorder(isReplying: isReplying),
        fillColor: Colors.white,
        hintText: hintText,
        isDense: true,
        prefixIcon: GestureDetector(
          onTap: onPrefixIconTap,
          child: Transform.rotate(
            angle: rotationalAngle,
            child: Icon(
              prefixIcon,
              size: prefixIconSize,
              color: AppColors.hintTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
