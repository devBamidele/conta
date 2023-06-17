import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../res/color.dart';
import '../../../../res/components/app_bar_icon.dart';
import '../../../../res/components/chat_text_form_field.dart';
import '../../../../res/components/custom/custom_back_button.dart';
import '../../../../res/components/media_preview.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/widget_functions.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  static const tag = '/preview_screen';

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final double customSize = 27;
  final _controller = PageController();

  final messagesFocusNode = FocusNode();
  final messagesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        final mediaFiles = data.pickerResult;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: CustomBackButton(
              padding: const EdgeInsets.only(left: 15),
              color: AppColors.extraTextColor,
              onPressed: () => data.clearPickerResult(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    addWidth(20),
                    AppBarIcon(
                      icon: IconlyLight.delete,
                      size: customSize,
                      onTap: () =>
                          data.removeFileFromPicker(_controller.page!.round()),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  constraints: const BoxConstraints.expand(),
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: mediaFiles.length,
                    itemBuilder: (_, int index) {
                      PlatformFile file = mediaFiles[index];
                      return MediaPreview(
                        file: file,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: mediaFiles.length,
                          effect: scrollingDotsEffect,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Padding(
                          padding: chatFieldPadding,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 5 * 16 * 1.4,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    reverse: true,
                                    child: ChatTextFormField(
                                      node: messagesFocusNode,
                                      controller: messagesController,
                                      prefixIcon:
                                          Icons.add_photo_alternate_outlined,
                                      rotationalAngle: 0,
                                      prefixIconSize: 26,
                                      onPrefixIconTap: _onPrefixIconTap,
                                      hintText: 'Add a caption',
                                    ),
                                  ),
                                ),
                              ),
                              addWidth(8),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: AppColors.primaryColor,
                                child: GestureDetector(
                                  onTap: () => _onSendMessageTap(data),
                                  child: Transform.rotate(
                                    angle: math.pi / 4,
                                    child: const Icon(
                                      IconlyBold.send,
                                      size: 23,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSendMessageTap(ChatMessagesProvider chatProvider) async {
    final caption = messagesController.value.text;

    showDialog(
      context: context,
      builder: (context) => Center(
        child: LoadingAnimationWidget.waveDots(
          color: AppColors.primaryShadeColor,
          size: 55,
        ),
      ),
    );

    try {
      await chatProvider.uploadImagesAndCaption(caption);
    } catch (e) {
      AppUtils.showToast(e.toString());
    } finally {
      // Clear the result and pop 2 stacks back
      chatProvider.clearPickerResult();
      context.router.popUntilRouteWithName('ChatScreenRoute');
    }
  }

  void _onPrefixIconTap() {}
}
