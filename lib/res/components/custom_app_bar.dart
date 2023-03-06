import 'package:conta/res/components/custom_back_button.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat.dart';
import '../../../../res/color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  final double customSize = 27;

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        Chat currentChat = data.currentChat!;
        return AppBar(
          titleSpacing: 10,
          leading: const CustomBackButton(
            padding: EdgeInsets.only(left: 15),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      IconlyLight.video,
                      color: AppColors.extraTextColor.withOpacity(0.8),
                      size: customSize,
                    ),
                  ),
                  addWidth(20),
                  Icon(
                    IconlyLight.call,
                    color: AppColors.extraTextColor.withOpacity(0.8),
                    size: customSize,
                  ),
                ],
              ),
            ),
          ],
          title: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage(currentChat.profilePic!),
              ),
              addWidth(15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentChat.username,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.2,
                      ),
                    ),
                    addHeight(2),
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 14.5,
                        color: AppColors.extraTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
