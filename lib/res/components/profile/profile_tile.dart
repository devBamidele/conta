import 'package:flutter/material.dart';

import '../../color.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.titleText,
    this.onTap,
    this.icon,
    this.leadingColor,
    this.showTrailing = true,
    this.subtitle,
  });

  final String titleText;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? leadingColor;
  final bool showTrailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: leadingColor ?? AppColors.blackColor,
      ),
      titleTextStyle: TextStyle(
        fontSize: subtitle != null ? 13 : 16,
        color: subtitle != null ? AppColors.blackShade : AppColors.blackColor,
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColors.blackColor,
      ),
      title: Text(
        titleText,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: showTrailing
          ? const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.blackColor,
            )
          : const SizedBox.shrink(),
    );
  }
}
