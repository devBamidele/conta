import 'package:flutter/material.dart';

import '../../../res/components/custom_value_color_anim.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({Key? key}) : super(key: key);

  static const tag = '/call_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: customValueColorAnim(),
        ),
      ),
    );
  }
}
