import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Person.dart';
import '../color.dart';

class OnlineStatus extends StatelessWidget {
  const OnlineStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<ChatProvider>(
      builder: (_, data, Widget? child) {
        return StreamBuilder<Person>(
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
            Person person = snapshot.data!;
            bool isOnline = person.online;
            String lastSeen = person.formatLastSeen(Timestamp.now());
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
