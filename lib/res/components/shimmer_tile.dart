import 'package:conta/res/components/shimmer_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/widget_functions.dart';

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 18,
      ),
      leading: const ShimmerWidget.circular(width: 54, height: 54),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: width * 0.1,
            child: ShimmerWidget.rectangular(
              border: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
              height: 15,
            ),
          ),
          addHeight(12),
          const ShimmerWidget.circular(width: 13, height: 13),
        ],
      ),
      title: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ShimmerWidget.rectangular(
              width: width * 0.3,
              height: 22,
              border: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
      subtitle: ShimmerWidget.rectangular(
        height: 12,
        border: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
