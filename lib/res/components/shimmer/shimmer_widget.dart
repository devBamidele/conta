import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double height;
  final ShapeBorder border;

  const ShimmerWidget({
    Key? key,
    required this.width,
    required this.height,
    this.border = const RoundedRectangleBorder(),
  }) : super(key: key);

  const ShimmerWidget.rectangular({
    super.key,
    required this.height,
    this.border = const RoundedRectangleBorder(),
    this.width,
  });

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.border = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: ShapeDecoration(
          shape: border,
          color: Colors.grey,
        ),
      ),
    );
  }
}
