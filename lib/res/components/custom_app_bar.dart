import 'package:auto_route/auto_route.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/conta_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat.dart';
import '../../../../res/color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _iconColor = AppColors.darkIconColor;

  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Consumer<ContaViewModel>(
      builder: (_, data, Widget? child) {
        Chat currentChat = data.currentChat!;
        return AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen
              context.router.pop();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/video_camera.png',
                    color: _iconColor,
                    scale: 2.5,
                  ),
                  addWidth(15),
                  Transform.rotate(
                    angle: -90 * 0.0174533, // Convert degrees to radians
                    child: Image.asset(
                      'assets/images/phone.png',
                      color: _iconColor,
                      scale: 2.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
          title: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage(currentChat.profilePic),
              ),
              addWidth(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentChat.sender,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
