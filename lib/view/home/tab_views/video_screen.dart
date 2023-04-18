import 'package:flutter/material.dart';

import '../../../res/components/shimmer_tile.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  static const tag = '/video_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ShimmerTile();
        },
      ),
    );
  }
}
