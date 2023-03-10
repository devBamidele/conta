import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../color.dart';
import '../style/component_style.dart';

class ChatTextFormField extends StatelessWidget {
  const ChatTextFormField({
    Key? key,
    required this.node,
    required this.controller,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
  }) : super(key: key);

  final FocusNode node;
  final TextEditingController controller;
  final VoidCallback? onPrefixIconTap;
  final VoidCallback? onSuffixIconTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 16,
        height: 1.4,
        letterSpacing: 0.2,
      ),
      maxLines: null,
      cursorColor: Colors.black,
      focusNode: node,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: chatInputBorder,
        focusedBorder: chatInputBorder,
        fillColor: Colors.white,
        hintText: 'Type Here',
        contentPadding: const EdgeInsets.all(18),
        prefixIcon: GestureDetector(
          onTap: onPrefixIconTap,
          child: const Icon(
            Icons.emoji_emotions_outlined,
            color: AppColors.hintTextColor,
            size: 28,
          ), //
        ),
        isDense: true,
        suffixIcon: GestureDetector(
          onTap: onSuffixIconTap,
          child: Transform.rotate(
            angle: -math.pi / 1.3,
            child: const Icon(
              Icons.attach_file_rounded,
              size: 28,
              color: AppColors.hintTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
