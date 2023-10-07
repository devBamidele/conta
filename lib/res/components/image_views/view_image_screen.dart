import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../color.dart';
import '../custom/custom_back_button.dart';
import '../custom/custom_value_color_anim.dart';

class ViewImageScreen extends StatelessWidget {
  final List<String> media;
  final String sender;
  final Timestamp timeSent;

  const ViewImageScreen({
    Key? key,
    required this.media,
    required this.sender,
    required this.timeSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(
          padding: EdgeInsets.only(left: 15),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender, style: AppTextStyles.titleMedium),
            addHeight(2),
            Text(
              media.length > 1
                  ? timeSent.toStringForMultiplePics()
                  : timeSent.toStringForSinglePic(),
              style: TextStyle(
                color: AppColors.blackShade,
                fontSize: 13,
              ),
            ),
          ],
        ),
        // Todo ( Extra Feature ) Add download image functionality
        /*
         actions: [
          Consumer<MessagesProvider>(
            builder: (_, data, __) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: AppBarIcon(
                  icon: IconlyLight.download,
                  size: 27,
                  onTap: () => data.downloadImages(imageUrls: media),
                ),
              );
            },
          )
        ],
         */
      ),
      body: SafeArea(
        child: media.length == 1
            ? Center(child: ImagePreview(url: media[0]))
            : ListView.builder(
                itemCount: media.length,
                itemBuilder: (__, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ImagePreview(url: media[index]),
                  );
                },
              ),
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  final String url;
  final String? tag;

  const ImagePreview({
    Key? key,
    required this.url,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag ?? url,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageProvider = CachedNetworkImageProvider(url);

          double imageWidth = 1;
          double imageHeight = 1;

          imageProvider.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener(
              (info, __) {
                imageWidth = info.image.width.toDouble();
                imageHeight = info.image.height.toDouble();
              },
            ),
          );

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxWidth * (imageHeight / imageWidth),
            ),
            child: PhotoView(
              imageProvider: imageProvider,
              backgroundDecoration: const BoxDecoration(
                color: AppColors.backGroundColor,
              ),
              loadingBuilder: (context, event) {
                if (event == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final progress =
                    event.cumulativeBytesLoaded / event.expectedTotalBytes!;

                return Center(
                  child: CircularProgressIndicator(
                    valueColor: customValueColorAnim(),
                    value: progress,
                  ),
                );
              },
              errorBuilder: (context, object, trace) {
                return const Center(child: Text('Error fetching data'));
              },
            ),
          );
        },
      ),
    );
  }
}
