import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../color.dart';
import '../style/component_style.dart';

class ChatTextFormField extends StatelessWidget {
  const ChatTextFormField({
    Key? key,
    required this.node,
    required this.controller,
    this.onPrefixIconTap,
    this.isReplying = false,
    this.prefixIcon = IconlyBold.image,
    this.prefixIconSize = 26,
    this.hintText = 'Message',
  }) : super(key: key);

  final FocusNode node;
  final TextEditingController controller;
  final VoidCallback? onPrefixIconTap;
  final IconData prefixIcon;
  final double prefixIconSize;
  final bool isReplying;
  final String hintText;

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
          child: Icon(
            prefixIcon,
            size: prefixIconSize,
            color: AppColors.hintTextColor,
          ),
        ),
      ),
    );
  }
}
