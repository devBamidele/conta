import 'package:flutter/material.dart';

import '../../utils/widget_functions.dart';
import '../color.dart';

class ReplyBubble extends StatelessWidget {
  const ReplyBubble(
      {Key? key,
      required this.replyMessage,
      required this.isSender,
      required this.username})
      : super(key: key);

  final String replyMessage;
  final bool isSender;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.replyMessageBackGround,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Expanded(
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      addHeight(3),
                      Text(
                        replyMessage,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                ),
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
    );
  }
}
