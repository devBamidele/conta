import 'dart:developer';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_router/router.gr.dart';
import 'dynamic_sized_image_preview.dart';
import 'image_grid_tile.dart';

class ImagePreview extends StatefulWidget {
  final List<String> media;
  final Timestamp timeSent;
  final String sender;

  const ImagePreview({
    Key? key,
    required this.media,
    required this.timeSent,
    required this.sender,
  }) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  void onMediaClicked() {
    log('Navigate');
    goToMediaPreview();
  }

  void goToMediaPreview() => context.router.push(
        MediaPreviewScreenRoute(
          media: widget.media,
          sender: widget.sender,
          timeSent: widget.timeSent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (widget.media.length >= 4) {
      return GestureDetector(
        onTap: onMediaClicked,
        child: GridView.builder(
          gridDelegate: customGridDelegate,
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 3 && widget.media.length > 4) {
              final remainingCount = widget.media.length - 4;
              return Stack(
                fit: StackFit.expand,
                children: [
                  ImageGridTile(
                    mediaUrl: widget.media[index],
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
                mediaUrl: widget.media[index],
              );
            }
          },
        ),
      );
    } else {
      return GestureDetector(
        onTap: onMediaClicked,
        child: DynamicSizedImagePreview(
          mediaUrl: widget.media[0],
        ),
      );
    }
  }
}
