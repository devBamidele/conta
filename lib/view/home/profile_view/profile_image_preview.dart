import 'package:auto_route/auto_route.dart';
import 'package:conta/res/components/confirmation_dialog.dart';
import 'package:conta/res/components/image_views/view_image_screen.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../res/components/app_bar_icon.dart';
import '../../../res/components/custom/custom_back_button.dart';
import '../../../res/style/component_style.dart';
import '../../../utils/app_utils.dart';

class ProfileImagePreview extends StatelessWidget {
  const ProfileImagePreview({
    super.key,
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, data, __) {
        return Scaffold(
          appBar: AppBar(
            leading: const CustomBackButton(
              padding: EdgeInsets.only(left: 15),
              color: AppColors.extraTextColor,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: AppBarIcon(
                  icon: IconlyLight.delete,
                  size: 27,
                  onTap: () => confirmDelete(context, data),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: pagePadding.copyWith(left: 10, right: 10),
              child: Center(
                child: ImagePreview(
                  url: path,
                  tag: 'Avatar',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void confirmDelete(BuildContext context, UserProvider data) async {
    const contextText =
        'Are you sure you want to remove your profile picture ?';

    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Remove Picture ?',
          contentText: contextText,
          validateText: 'Remove',
          onConfirmPressed: () {
            data.removeProfilePic(showSnackbar: showSnackbar);
            context.router.popUntilRouteWithName('ProfileScreenRoute');
          },
        );
      },
    );
  }

  void showSnackbar(String message) {
    AppUtils.showSnackbar(message);
  }
}
