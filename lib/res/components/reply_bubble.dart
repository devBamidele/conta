import 'package:flutter/material.dart';

import '../color.dart';

class ReplyBubble extends StatelessWidget {
  const ReplyBubble({
    Key? key,
    required this.replyMessage,
    required this.isSender,
    required this.username,
  }) : super(key: key);

  final String replyMessage;
  final bool isSender;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(11.5),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.transparentBackground,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 7, 7, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isSender ? 'You' : username,
                          style: const TextStyle(
                            color: AppColors.replyMessageColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    replyMessage,
                    maxLines: 2,
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
              width: 4,
              color: AppColors.replyMessageColor,
              height: 100,
            ),
          )
        ],
      ),
    );
  }
}
