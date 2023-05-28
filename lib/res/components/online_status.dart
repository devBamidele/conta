import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';

import '../color.dart';

class OnlineStatus extends StatelessWidget {
  const OnlineStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: data.getOnlineStatusStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ShimmerWidget.rectangular(
                width: width * 0.1,
                height: 10,
                border: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }
            bool isOnline = snapshot.data!.get('online') ?? false;
            Timestamp time = snapshot.data!.get('lastSeen');
            String lastSeen = time.lastSeen(Timestamp.now());
            return Text(
              isOnline ? 'Online' : lastSeen,
              style: TextStyle(
                color: isOnline
                    ? AppColors.primaryColor
                    : AppColors.extraTextColor,
                fontSize: 13,
              ),
            );
          },
        );
      },
    );
  }
}
