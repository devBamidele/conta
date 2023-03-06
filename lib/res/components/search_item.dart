import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../models/search_user.dart';
import '../../utils/widget_functions.dart';
import '../color.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    required this.user,
    required this.onCancelTap,
    this.onTileTap,
  }) : super(key: key);

  final SearchUser user;
  final VoidCallback? onCancelTap;
  final VoidCallback? onTileTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: Icon(
          IconlyBold.profile,
          color: Color(0xFF9E9E9E),
          size: 25,
        ),
      ),
      trailing: onCancelTap != null
          ? IconButton(
              padding: const EdgeInsets.only(left: 20),
              onPressed: onCancelTap,
              icon: const Icon(
                Icons.clear_rounded,
                size: 28,
                color: AppColors.opaqueTextColor,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.timestamp.timeFormat(),
                  style: const TextStyle(color: AppColors.extraTextColor),
                ),
                addHeight(6),
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.greenAccent,
                  size: 20,
                )
              ],
            ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontSize: 18,
          height: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
      subtitle: const Padding(
        padding: EdgeInsets.only(top: 2),
        child: Text(
          'This is some extra text',
          style: TextStyle(color: AppColors.extraTextColor),
        ),
      ),
    );
  }
}
