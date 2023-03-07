import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../models/chat.dart';
import '../../utils/widget_functions.dart';
import '../color.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key? key,
    required this.chat,
    this.onCancelTap,
    this.onTileTap,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback? onCancelTap;
  final VoidCallback? onTileTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: Icon(
          IconlyBold.profile,
          color: Color(0xFF9E9E9E),
          size: 25,
        ),
      ),
      trailing: onCancelTap != null
          ? IconButton(
              padding: const EdgeInsets.only(left: 20),
              onPressed: onCancelTap,
              icon: const Icon(
                Icons.clear_rounded,
                size: 28,
                color: AppColors.opaqueTextColor,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '12 : 44 PM',
                  style: TextStyle(color: AppColors.extraTextColor),
                ),
                addHeight(6),
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.greenAccent,
                  size: 20,
                )
              ],
            ),
      title: const Text(
        'Bamidele',
        style: TextStyle(
          fontSize: 18,
          height: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
      subtitle: const Padding(
        padding: EdgeInsets.only(top: 2),
        child: Text(
          'This is some extra text',
          style: TextStyle(color: AppColors.extraTextColor),
        ),
      ),
    );
  }
}
