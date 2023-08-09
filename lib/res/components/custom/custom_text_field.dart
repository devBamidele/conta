import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.focusNode,
    required this.textController,
    required this.customFillColor,
    required this.hintText,
    this.prefixIcon,
    this.validation,
    this.suffixIcon,
    this.obscureText = false,
    this.action = TextInputAction.next,
    this.onFieldSubmitted,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textController;
  final void Function(String)? onFieldSubmitted;
  final Color customFillColor;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validation;
  final TextInputAction action;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      focusNode: focusNode,
      controller: textController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      textInputAction: action,
      validator: validation,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        isDense: true,
        fillColor: customFillColor.withOpacity(0.5),
        hintText: hintText,
        contentPadding: const EdgeInsets.all(18),
        prefixIcon: Visibility(
          visible: prefixIcon != null ? true : false,
          child: Padding(
            padding: const EdgeInsets.only(left: 22, right: 14),
            child: prefixIcon,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
