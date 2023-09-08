import 'package:conta/res/components/unread_identifier.dart';
import 'package:conta/view_model/messages_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/chat.dart';
import '../../color.dart';

class CustomScrollButton extends StatelessWidget {
  CustomScrollButton({
    Key? key,
    required this.showIcon,
    this.onPressed,
  }) : super(key: key);

  final bool showIcon;
  final VoidCallback? onPressed;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (_, data, __) {
        return Visibility(
          visible: showIcon,
          child: SizedBox.square(
            dimension: 50,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FittedBox(
                    child: FloatingActionButton(
                      elevation: 4,
                      backgroundColor: Colors.white,
                      onPressed: onPressed,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 45,
                        color: AppColors.extraTextColor,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<Chat>(
                  stream: data.getUnreadCountStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    final chatData = snapshot.data!;

                    final count = chatData.unreadCount;
                    final samePerson = chatData.lastSenderUserId == userId;
                    if (count > 0 && !samePerson) {
                      return Positioned(
                        right: 2,
                        top: 2,
                        child: UnReadIdentifier(
                          unread: count,
                        ), //
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
