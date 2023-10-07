import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_router/router.gr.dart';
import 'grid_image_tile.dart';
import 'single_image_tile.dart';

class ImageTile extends StatelessWidget {
  final List<String> media;
  final Timestamp timeSent;
  final String sender;
  final String chatId;

  const ImageTile({
    Key? key,
    required this.media,
    required this.timeSent,
    required this.sender,
    required this.chatId,
  }) : super(key: key);

  void goToMediaPreview(BuildContext context) => navPush(
        context,
        ViewImageScreenRoute(
          media: media,
          sender: sender,
          timeSent: timeSent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(11.5)),
        child: SizedBox(
          child: (media.length >= 4)
              ? GestureDetector(
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
                            GridImageTile(
                              mediaUrl: media[index],
                            ),
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 0.5,
                                    sigmaY: 0.5,
                                  ),
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
                        return GridImageTile(
                          mediaUrl: media[index],
                        );
                      }
                    },
                  ),
                )
              : SingleImageTile(
                  sender: sender,
                  timeSent: timeSent,
                  mediaUrl: media.first,
                ),
        ),
      ),
    );
  }
}
