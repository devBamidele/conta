import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:conta/utils/enums.dart';
import 'package:conta/view_model/messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/person.dart';
import '../color.dart';

class Status extends StatelessWidget {
  final bool isDialog;
  final StreamType type;
  final bool? isDeleted;

  const Status({
    Key? key,
    this.isDialog = false,
    this.type = StreamType.onlineStatus,
    this.isDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (_, data, __) {
        return StreamBuilder<Person>(
          stream: data.getStatusStream(),
          builder: (context, snapshot) {
            if (isDeleted != null && isDeleted!) {
              return buildDeletedText();
            }
            if (!snapshot.hasData) {
              return buildShimmer(context);
            }
            return buildStatusText(snapshot.data!);
          },
        );
      },
    );
  }

  Widget buildShimmer(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ShimmerWidget.rectangular(
      width: width * 0.3,
      height: 10,
      border: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget buildDeletedText() {
    return const Text(
      'Account Deleted',
      style: TextStyle(
        color: AppColors.extraTextColor,
        fontSize: 13,
      ),
    );
  }

  Widget buildStatusText(Person person) {
    switch (type) {
      case StreamType.bio:
        return Text(
          person.bio,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w500,
          ),
        );
      case StreamType.onlineStatus:
        bool isOnline = person.online;
        String lastSeen = person.formatLastSeen(Timestamp.now());
        return Text(
          isOnline ? 'Online' : lastSeen,
          style: TextStyle(
            color: isDialog
                ? Colors.white
                : isOnline
                    ? AppColors.primaryColor
                    : AppColors.blackShade,
            fontSize: 13,
          ),
        );
      default:
        return const SizedBox.shrink(); // Handle other cases as needed
    }
  }
}
