import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/models/search_results.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:flutter/material.dart';

import '../../utils/app_router/router.gr.dart';
import '../../utils/widget_functions.dart';
import '../color.dart';
import '../style/component_style.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.person,
    this.onTap,
    required this.isSamePerson,
  });

  final SearchResults person;
  final VoidCallback? onTap;
  final bool isSamePerson;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        child: _buildProfileImage(context),
      ),
      title: _buildUsername(),
      contentPadding: tileContentPadding,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: _buildBio(),
      ),
    );
  }

  Widget _buildBio() {
    return Text(
      isSamePerson ? 'Message yourself' : person.bio,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: AppColors.blackShade),
    );
  }

  Widget _buildUsername() {
    return Row(
      children: [
        Text(
          person.username,
          style: AppTextStyles.listTileTitleText,
        ),
        addWidth(2),
        Text(
          isSamePerson ? '(You)' : '',
          style: AppTextStyles.listTileTitleText,
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    final imageUrl = person.profilePicUrl;

    final username = person.username;

    return imageUrl != null
        ? GestureDetector(
            onTap: () => navPush(
              context,
              UserPicViewRoute(
                path: imageUrl,
                username: username,
                samePerson: isSamePerson,
                tag: '$imageUrl from contacts',
              ),
            ),
            child: Hero(
              tag: '$imageUrl from contacts',
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const ShimmerWidget.circular(width: 54, height: 54),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          )
        : noProfilePic();
  }
}
