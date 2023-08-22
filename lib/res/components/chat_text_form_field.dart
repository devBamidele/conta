import 'package:conta/res/style/app_text_style.dart';
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
    this.onFieldSubmitted,
  }) : super(key: key);

  final FocusNode node;
  final void Function(String)? onFieldSubmitted;
  final TextEditingController controller;
  final VoidCallback? onPrefixIconTap;
  final IconData prefixIcon;
  final double prefixIconSize;
  final bool isReplying;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyles.formText,
      maxLines: null,
      cursorColor: AppColors.blackColor,
      focusNode: node,
      textInputAction: TextInputAction.send,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
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
