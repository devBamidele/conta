import 'package:conta/res/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../color.dart';
import '../shimmer/shimmer_widget.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.titleText,
    this.onTap,
    this.icon,
    this.leadingColor,
    this.showTrailing = true,
    this.showSubtitle = false,
    this.subtitle,
  });

  final String titleText;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? leadingColor;
  final bool showTrailing;
  final String? subtitle;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: leadingColor ?? AppColors.blackColor,
      ),
      titleTextStyle: subtitle != null
          ? TextStyle(
              fontSize: 13,
              color: AppColors.blackShade,
              fontWeight: FontWeight.normal,
            )
          : AppTextStyles.profileTileSubtitle,
      subtitleTextStyle: AppTextStyles.profileTileSubtitle,
      title: Text(
        titleText,
        style: GoogleFonts.urbanist(letterSpacing: 0.4),
      ),
      subtitle: showSubtitle == true ? _showSubtitleText() : null,
      trailing: showTrailing
          ? const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.blackColor,
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _showSubtitleText() {
    return subtitle != null
        ? Text(subtitle!)
        : ShimmerWidget.rectangular(
            height: 12,
            border: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          );
  }
}
