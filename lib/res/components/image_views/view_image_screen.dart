import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/res/components/app_bar_icon.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

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
          color: AppColors.extraTextColor,
        ),
        title: DefaultTextStyle(
          style: const TextStyle(
            color: AppColors.blackColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                ),
              ),
              addHeight(2),
              Text(
                media.length > 1
                    ? timeSent.toStringForMultiplePics()
                    : timeSent.toStringForSinglePic(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
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
      child: Image(
        image: CachedNetworkImageProvider(url),
        loadingBuilder: (context, child, progress) {
          return progress == null
              ? child
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: customValueColorAnim(),
                    value: progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!,
                  ),
                );
        },
        errorBuilder: (context, object, trace) {
          return const Center(child: Text('Error fetching data'));
        },
      ),
    );
  }
}
