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
  }) : super(key: key);

  final FocusNode node;
  final TextEditingController controller;
  final VoidCallback? onPrefixIconTap;

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
        enabledBorder: chatInputBorder,
        focusedBorder: chatInputBorder,
        fillColor: Colors.white,
        hintText: 'Message',
        isDense: true,
        prefixIcon: GestureDetector(
          onTap: onPrefixIconTap,
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
