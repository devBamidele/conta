import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/custom_back_button.dart';
import 'package:conta/res/components/online_status.dart';
import 'package:conta/res/components/shimmer_widget.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  final double customSize = 27;

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        final currentChat = data.currentChat!;
        return AppBar(
          surfaceTintColor: AppColors.appBarColor,
          titleSpacing: 5,
          leading: CustomBackButton(
            padding: const EdgeInsets.only(left: 15),
            color: AppColors.extraTextColor,
            onPressed: () => data.cancelReply(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      IconlyLight.video,
                      color: AppColors.extraTextColor,
                      size: customSize,
                    ),
                  ),
                  addWidth(20),
                  Icon(
                    IconlyLight.call,
                    color: AppColors.extraTextColor,
                    size: customSize,
                  ),
                ],
              ),
            ),
          ],
          title: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.white,
                child: currentChat.profilePicUrl != null
                    ? CachedNetworkImage(
                        imageUrl: currentChat.profilePicUrl!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const ShimmerWidget.circular(width: 46, height: 46),
                        errorWidget: (context, url, error) =>
                            const ShimmerWidget.circular(width: 46, height: 46),
                      )
                    : const Icon(
                        IconlyBold.profile,
                        color: Color(0xFF9E9E9E),
                        size: 25,
                      ),
              ),
              addWidth(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentChat.username,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 17.5,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    addHeight(2),
                    const OnlineStatus(),
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
