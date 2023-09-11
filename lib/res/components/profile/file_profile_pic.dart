import 'dart:io';

import 'package:flutter/material.dart';

import '../../../utils/widget_functions.dart';
import '../../color.dart';
import '../shimmer/shimmer_widget.dart';

class FileProfilePic extends StatelessWidget {
  final File? imageFile;
  final bool isHomeScreen;

  const FileProfilePic({
    Key? key,
    this.imageFile,
    this.isHomeScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      // If imageFile is null, return the noProfilePic widget

      if (isHomeScreen) {
        return const ShimmerWidget.circular(width: 54, height: 54);
      }

      return CircleAvatar(
        backgroundColor: AppColors.photoContainerColor,
        child: noProfilePic(size: 48),
      );
    } else {
      // If imageFile is not null, display the profile picture
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: FileImage(imageFile!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
