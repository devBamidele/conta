import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/widget_functions.dart';
import '../../../view_model/user_provider.dart';
import 'file_profile_pic.dart';

class UrlProfilePic extends StatelessWidget {
  const UrlProfilePic({
    super.key,
    this.noPicSize,
  });

  final double? noPicSize;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, data, __) {
        return StreamBuilder<String?>(
          initialData: data.userData?.profilePicUrl,
          stream: data.getProfilePic(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final url = snapshot.data;

              return CachedNetworkImage(
                imageUrl: url!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => FileProfilePic(
                  imageFile: data.profilePic,
                  isHomeScreen: true,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fadeOutDuration: Duration.zero,
                fadeInDuration: Duration.zero,
              );
            } else {
              return noProfilePic(size: noPicSize ?? 25);
            }
          },
        );
      },
    );
  }
}
