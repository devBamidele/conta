import 'package:conta/models/response.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/messages_provider.dart';

class Intermediary extends StatefulWidget {
  const Intermediary({
    super.key,
    required this.data,
  });

  final Response data;

  @override
  State<Intermediary> createState() => _IntermediaryState();
}

class _IntermediaryState extends State<Intermediary> {
  final user = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    final profilePic = widget.data.senderProfilePic != 'null'
        ? widget.data.senderProfilePic
        : null;

    final chatProvider = Provider.of<MessagesProvider>(context, listen: false);

    chatProvider.setCurrentChat(
      username: widget.data.username,
      uidUser1: user,
      uidUser2: widget.data.uidUser2,
      profilePicUrl: profilePic,
      bio: widget.data.bio,
      name: widget.data.name,
      notifications: widget.data.notifications,
      oppIndex: widget.data.oppIndex,
    );

    navReplace(context, const ChatScreenRoute());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
