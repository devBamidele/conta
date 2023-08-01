import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_router/router.gr.dart';
import 'dynamic_sized_image_preview.dart';
import 'image_grid_tile.dart';

class ImagePreview extends StatelessWidget {
  final List<String> media;
  final Timestamp timeSent;
  final String sender;
  final String chatId;

  const ImagePreview({
    Key? key,
    required this.media,
    required this.timeSent,
    required this.sender,
    required this.chatId,
  }) : super(key: key);

  void goToMediaPreview(BuildContext context) => context.router.push(
        MediaPreviewScreenRoute(
          media: media,
          sender: sender,
          timeSent: timeSent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (media.length >= 4) {
      return GestureDetector(
        onTap: () => goToMediaPreview(context),
        child: GridView.builder(
          gridDelegate: customGridDelegate,
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 3 && media.length > 4) {
              final remainingCount = media.length - 4;
              return Stack(
                fit: StackFit.expand,
                children: [
                  ImageGridTile(
                    mediaUrl: media[index],
                  ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                        child: Container(
                          color: Colors.black54.withOpacity(0.7),
                          child: Center(
                            child: Text(
                              '+ $remainingCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return ImageGridTile(
                mediaUrl: media[index],
              );
            }
          },
        ),
      );
    } else {
      return DynamicSizedImagePreview(
        sender: sender,
        timeSent: timeSent,
        mediaUrl: media.first,
      );
    }
  }
}
