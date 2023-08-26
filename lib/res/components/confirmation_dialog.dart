import 'package:flutter/material.dart';

import '../color.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String contentText;

  final String? validateText;
  final String? cancelText;

  final VoidCallback? onConfirmPressed;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.contentText,
    this.onConfirmPressed,
    this.validateText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      titlePadding: const EdgeInsets.only(left: 18, top: 20),
      content: Text(contentText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText ?? 'Cancel'),
        ),
        TextButton(
          onPressed: onConfirmPressed ?? () => Navigator.of(context).pop(true),
          child: Text(
            validateText ?? 'Delete',
            style: TextStyle(
              color: AppColors.errorBorderColor.withOpacity(0.7),
            ),
          ),
        ),
      ],
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
    );
  }
}
