import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.titleText,
    this.onTap,
    this.leading,
  });

  final String titleText;
  final VoidCallback? onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(titleText),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
