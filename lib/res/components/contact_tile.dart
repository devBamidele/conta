import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/shimmer/shimmer_widget.dart';
import 'package:flutter/material.dart';

import '../../models/Person.dart';
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

  final Person person;
  final VoidCallback? onTap;
  final bool isSamePerson;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        child: _buildProfileImage(),
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
          style: const TextStyle(
            fontSize: 18,
            height: 1.2,
            color: Colors.black,
          ),
        ),
        addWidth(2),
        Text(
          isSamePerson ? '(You)' : '',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    final imageUrl = person.profilePicUrl;

    return imageUrl != null
        ? CachedNetworkImage(
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
          )
        : noProfilePic();
  }
}
