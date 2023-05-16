import 'package:flutter/material.dart';

import '../color.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String contentText;
  final VoidCallback onConfirmPressed;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.contentText,
    required this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(contentText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirmPressed,
          child: Text(
            'Delete',
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
