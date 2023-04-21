import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../utils/widget_functions.dart';


class ReplyMessage extends StatelessWidget {
  final Message message;
  final String? senderName;
  final VoidCallback? onCancelReply;

  const ReplyMessage({
    Key? key,
    required this.message,
    this.senderName,
    this.onCancelReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              color: Colors.red,
              width: 4,
            ),
            addWidth(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          senderName ?? 'NoName',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (onCancelReply != null)
                        GestureDetector(
                          onTap: onCancelReply,
                          child: const Icon(
                            Icons.close,
                            size: 18,
                          ),
                        )
                    ],
                  ),
                  addHeight(8),
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
