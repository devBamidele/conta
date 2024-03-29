import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/online_status.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/enums.dart';
import '../../../utils/widget_functions.dart';
import '../../../view_model/messages_provider.dart';
import '../shimmer/shimmer_widget.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (_, data, __) {
        final imageUrl = data.currentChat!.profilePicUrl;

        final extraPadding = ((data.currentChat!.oppIndex != null &&
                data.currentChat!.uidUser1 != data.currentChat!.uidUser2)) &&
            !data.currentChat!.isBlocked;

        return Dialog(
          clipBehavior: Clip.hardEdge,
          child: Container(
            color: Colors.white,
            height: extraPadding ? 360 : 317,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          imageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const ShimmerWidget.circular(
                                    width: 46,
                                    height: 46,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const ShimmerWidget.circular(
                                    width: 46,
                                    height: 46,
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    IconlyBold.profile,
                                    color: AppColors.hintTextColor,
                                    size: 42,
                                  ),
                                ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 100,
                              decoration: profileDialogShade,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    data.currentChat!.username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Status(isDialog: true),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Info',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryShadeColor,
                              fontSize: 18,
                            ),
                          ),
                          addHeight(8),
                          Text(
                            'Bio',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.blackShade,
                            ),
                          ),
                          data.currentChat!.bio != null
                              ? Text(
                                  data.currentChat!.bio!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : const Status(type: StreamType.bio),
                          if (extraPadding)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Notifications',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.blackShade,
                                  ),
                                ),
                                NotificationSwitch(
                                  enabled: data.currentChat!.notifications,
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({
    super.key,
    required this.enabled,
  });

  final bool enabled;

  @override
  State<NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool enabled = true;

  @override
  void initState() {
    enabled = widget.enabled;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final trackOutlineColor = MaterialStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return null;
        } else {
          return AppColors.continueWithColor.withOpacity(0.8);
        }
      },
    );

    final trackColor = MaterialStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryShadeColor.withOpacity(0.5);
        } else {
          return AppColors.opaqueTextColor.withOpacity(0.25);
        }
      },
    );

    final thumbColor = MaterialStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        } else {
          return AppColors.continueWithColor.withOpacity(0.8);
        }
      },
    );

    onSwitchChanged(bool value, MessagesProvider data, ChatProvider chat) {
      final currentChat = data.currentChat!;

      setState(() {
        enabled = value;
      });

      AppUtils.showToast(
          '${enabled ? 'Un-muted' : 'Muted'} notifications from ${currentChat.username}');

      final oppIndex = currentChat.oppIndex!;

      chat.toggleMutedStatus(
        chatId: currentChat.chatId!,
        index: oppIndex,
        newValue: !enabled,
      );

      data.updateCurrentChat(notifications: value);
    }

    return Consumer2<MessagesProvider, ChatProvider>(
      builder: (_, data, chat, __) {
        return Switch.adaptive(
          value: enabled,
          trackOutlineColor: trackOutlineColor,
          trackColor: trackColor,
          thumbColor: thumbColor,
          onChanged: (newValue) {
            onSwitchChanged(newValue, data, chat);
          },
        );
      },
    );
  }
}
