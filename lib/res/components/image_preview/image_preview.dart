import 'dart:ui';

import 'package:conta/res/style/component_style.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../color.dart';
import 'image_grid_tile.dart';
import 'image_preview_item.dart';

class ImagePreview extends StatefulWidget {
  final List<String> media;

  const ImagePreview({
    Key? key,
    required this.media,
  }) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  List<Size?> imageSizes = [];

  @override
  void initState() {
    super.initState();
    loadImageSizes();
  }

  void loadImageSizes() {
    for (var mediaItem in widget.media) {
      Image.network(mediaItem)
          .image
          .resolve(const ImageConfiguration())
          .addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          if (mounted) {
            setState(() {
              imageSizes.add(Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              ));
            });
          }
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageSizes.isNotEmpty) {
      if (widget.media.length >= 4) {
        return GridView.builder(
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
        );
      } else {
        return ImagePreviewItem(
          mediaUrl: widget.media[0],
          imageSize: imageSizes[0]!,
        );
      }
    }

    // Placeholder widget while the image dimensions are being fetched
    return Container(
      height: 90,
      color: Colors.transparent,
      child: Center(
        child: LoadingAnimationWidget.discreteCircle(
          size: 30,
          color: AppColors.mainRingColor,
          secondRingColor: AppColors.secondRingColor,
          thirdRingColor: AppColors.thirdRingColor,
        ),
      ),
    );
  }
}
