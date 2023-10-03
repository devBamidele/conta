import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:conta/utils/enums.dart';
import 'package:conta/view_model/messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../models/person.dart';
import '../color.dart';

class Status extends StatefulWidget {
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
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  late StreamSubscription subscription;
  late MessagesProvider data;

  @override
  void initState() {
    super.initState();

    data = Provider.of<MessagesProvider>(context, listen: false);

    getConnectivity();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> getConnectivity() async {
    subscription = Connectivity().onConnectivityChanged.listen(
      (result) async {
        data.isConnected = await InternetConnectionChecker().hasConnection;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (_, data, __) {
        return StreamBuilder<Person>(
          stream: data.getStatusStream(),
          builder: (context, snapshot) {
            if (widget.isDeleted != null && widget.isDeleted!) {
              return buildDeletedText();
            }
            if (!snapshot.hasData) {
              return buildShimmer(context);
            }
            return buildStatusText(snapshot.data!, data.isConnected);
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

  Widget buildStatusText(Person person, bool isConnected) {
    switch (widget.type) {
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
          isConnected
              ? isOnline
                  ? 'Online'
                  : lastSeen
              : 'Waiting for network',
          style: TextStyle(
            color: widget.isDialog
                ? Colors.white
                : isOnline
                    ? isConnected
                        ? AppColors.primaryColor
                        : AppColors.blackShade
                    : AppColors.blackShade,
            fontSize: 13,
          ),
        );
      default:
        return const SizedBox.shrink(); // Handle other cases as needed
    }
  }
}
