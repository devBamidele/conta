import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../res/color.dart';
import '../../../../res/components/app_bar_icon.dart';
import '../../../../res/components/chat_text_form_field.dart';
import '../../../../res/components/custom/custom_back_button.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/widget_functions.dart';
import '../../../../view_model/photo_provider.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late PhotoProvider photoProvider;
  final _controller = PageController();

  final messagesFocusNode = FocusNode();
  final messagesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    photoProvider = Provider.of<PhotoProvider>(context, listen: false);
  }

  onDeleteTap(int length) {
    final page = _controller.page!.round();

    if (length == 1) {
      context.router.pop();
    }

    photoProvider.removeFileFromPicker(page);
  }

  Future<bool> onScreenPop() async {
    photoProvider.clearPickerResult();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoProvider>(
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
                        return MediaPreview(
                          file: mediaFiles[index],
                        );
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
                                    onTap: () => onSendMessageTap(),
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

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  void onUpload() {
    context.router.popUntilRouteWithName('ChatScreenRoute');
  }

  void onSendMessageTap() async {
    final caption = messagesController.text.trim();

    await photoProvider.sendImagesAndCaption(
      context: context,
      caption: caption,
      showSnackbar: showSnackbar,
      onUpload: onUpload,
    );
  }

  Future<void> _onPrefixIconTap() async {
    try {
      await photoProvider.chooseFiles();
    } catch (e) {
      AppUtils.showSnackbar(e.toString());
    }
  }
}

class MediaPreview extends StatelessWidget {
  const MediaPreview({
    Key? key,
    required this.file,
  }) : super(key: key);

  final PlatformFile file;

  @override
  Widget build(BuildContext context) {
    final ext = file.extension?.toLowerCase();

    if (ext == 'jpg' ||
        ext == 'png' ||
        ext == 'jpeg' ||
        ext == 'gif' ||
        ext == 'bmp' ||
        ext == 'webp' ||
        ext == 'webp_animated' ||
        ext == 'ico') {
      // Use FutureBuilder to asynchronously load the image
      return FutureBuilder<Uint8List>(
        future: File(file.path!).readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the image to load, show a loading indicator
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.replyMessageColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error loading image: ${snapshot.error}');
          } else {
            return Image.memory(snapshot.data!);
          }
        },
      );
    } else {
      return Center(
        child: Text('File support coming soon : $ext'),
      );
    }
  }
}
