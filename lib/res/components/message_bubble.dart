import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../color.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.isMe,
    required this.text,
    required this.timeSent,
    required this.unread,
  }) : super(key: key);

  final String text;
  final bool isMe;
  final Timestamp timeSent;
  final bool unread;

  final double edges = 15;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.8, // set the max width to 250
                ),
                child: Material(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(edges),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : Radius.circular(edges),
                    topLeft: isMe
                        ? Radius.circular(edges)
                        : const Radius.circular(0),
                    topRight: Radius.circular(edges),
                  ),
                  color: isMe ? AppColors.primaryColor : Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 3,
                  left: 5,
                ),
                child: Text(
                  timeSent.timeFormat(),
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
