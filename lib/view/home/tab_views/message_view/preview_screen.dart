import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/view_model/chat_provider.dart';
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

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late ChatProvider chatProvider;
  final _controller = PageController();

  final messagesFocusNode = FocusNode();
  final messagesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  onDeleteTap(int length) {
    if (length == 1) {
      context.router.pop();
    }
    chatProvider.removeFileFromPicker(_controller.page!.round());
  }

  Future<bool> onScreenPop() async {
    chatProvider.clearPickerResult();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, data, __) {
        final mediaFiles = data.pickerResult;
        return WillPopScope(
          onWillPop: onScreenPop,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: const CustomBackButton(
                padding: EdgeInsets.only(left: 15),
                color: AppColors.extraTextColor,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: AppBarIcon(
                    icon: IconlyLight.delete,
                    size: 27,
                    onTap: () => onDeleteTap(mediaFiles.length),
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
                        return MediaPreview(file: mediaFiles[index]);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: mediaFiles.length,
                      effect: scrollingDotsEffect,
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Padding(
                            padding: chatFieldPadding,
                            child: Row(
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
                                            Icons.add_photo_alternate_rounded,
                                        onPrefixIconTap: _onPrefixIconTap,
                                        hintText: 'Add a caption',
                                      ),
                                    ),
                                  ),
                                ),
                                addWidth(8),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.primaryColor,
                                  child: GestureDetector(
                                    onTap: () => _onSendMessageTap(data),
                                    child: Transform.rotate(
                                      angle: math.pi / 4,
                                      child: sendIcon(),
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
          ),
        );
      },
    );
  }

  void _onSendMessageTap(ChatProvider chatProvider) async {
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

  Future<void> _onPrefixIconTap() async {
    try {
      await chatProvider.chooseFiles();
    } catch (e) {
      AppUtils.showToast('Hello World');
    }
  }
}
