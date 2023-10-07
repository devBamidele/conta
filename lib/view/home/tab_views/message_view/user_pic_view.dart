import 'package:conta/res/style/component_style.dart';
import 'package:flutter/material.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom/custom_back_button.dart';
import '../../../../res/components/image_views/view_image_screen.dart';

class UserPicView extends StatelessWidget {
  const UserPicView({
    super.key,
    required this.tag,
    required this.path,
    required this.username,
    required this.samePerson,
  });

  final String tag;
  final String path;
  final String username;
  final bool samePerson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(
          padding: EdgeInsets.only(left: 15),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            '$username ${samePerson ? '(You)' : ''}',
            style: const TextStyle(
              color: AppColors.blackColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: pagePadding.copyWith(left: 10, right: 10),
          child: Center(
            child: ImagePreview(
              url: path,
              tag: tag,
            ),
          ),
        ),
      ),
    );
  }
}
