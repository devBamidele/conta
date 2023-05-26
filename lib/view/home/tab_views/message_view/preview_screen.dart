import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom_back_button.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            leading: CustomBackButton(
              padding: const EdgeInsets.only(left: 15),
              color: AppColors.extraTextColor,
              onPressed: () => data.clearPickerResult(),
            ),
            title: const Text('Image Preview'),
          ),
        );
      },
    );
  }
}
