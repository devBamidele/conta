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
      content: Text(contentText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText ?? 'Cancel'),
        ),
        TextButton(
          onPressed: onConfirmPressed,
          child: Text(
            validateText ?? 'Delete',
            style: TextStyle(
              color: AppColors.errorBorderColor.withOpacity(0.7),
            ),
          ),
        ),
      ],
      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(0, 5, 10, 10),
    );
  }
}
