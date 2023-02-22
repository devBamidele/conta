import 'package:conta/view/home/tab_views/message_view/message_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conta/view_model/conta_view_model.dart';

import '../../../../res/color.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  static const tag = '/message_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ContaViewModel>(
        builder: (_, data, Widget? child) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 25),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          size: 28,
                          color: AppColors.inactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: MessageListView(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
