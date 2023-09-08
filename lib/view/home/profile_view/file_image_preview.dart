import 'dart:io';

import 'package:flutter/material.dart';

import '../../../res/color.dart';
import '../../../res/components/custom/custom_back_button.dart';
import '../../../res/style/component_style.dart';

class FileImagePreview extends StatelessWidget {
  const FileImagePreview({super.key, this.imageFile});

  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(
          padding: EdgeInsets.only(left: 15),
          color: AppColors.extraTextColor,
        ),
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
