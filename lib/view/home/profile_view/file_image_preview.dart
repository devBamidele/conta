import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../res/color.dart';
import '../../../res/components/app_bar_icon.dart';
import '../../../res/components/custom/custom_back_button.dart';
import '../../../res/style/component_style.dart';

class FileImagePreview extends StatelessWidget {
  const FileImagePreview({
    super.key,
    this.imageFile,
    this.fromSignUp = false,
  });

  final File? imageFile;
  final bool fromSignUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(
          padding: EdgeInsets.only(left: 15),
          color: AppColors.extraTextColor,
        ),
        actions: [
          if (fromSignUp)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: AppBarIcon(
                icon: IconlyLight.delete,
                size: 27,
                onTap: () => context.router.pop(true),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: pagePadding.copyWith(left: 10, right: 10),
          child: Center(
            child: Hero(
              tag: 'Avatar',
              child: Image(
                image: FileImage(imageFile!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
