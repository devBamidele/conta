import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../utils/widget_functions.dart';

class ReplyMessage extends StatelessWidget {
  final Message message;
  final String? senderName;
  final VoidCallback? onCancelReply;
  final bool isYou;

  const ReplyMessage({
    Key? key,
    required this.message,
    required this.isYou,
    this.senderName,
    this.onCancelReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.transparentBackground,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 5, 5, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isYou ? 'You' : senderName ?? 'NoName',
                            style: const TextStyle(
                              color: AppColors.replyMessageColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
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
                    addHeight(3),
                    Text(
                      message.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.transparentText,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                width: 5,
                color: AppColors.replyMessageColor,
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
