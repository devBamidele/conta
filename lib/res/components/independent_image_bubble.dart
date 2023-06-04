import 'package:blur/blur.dart';
import 'package:conta/res/components/bubble_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../view_model/chat_messages_provider.dart';
import '../color.dart';
import 'image_preview/image_preview.dart';

class IndependentImageBubble extends StatefulWidget {
  final bool isSender;
  final Color color;
  final String media;
  final String timeSent;

  const IndependentImageBubble({
    Key? key,
    required this.isSender,
    required this.color,
    required this.media,
    required this.timeSent,
  }) : super(key: key);

  @override
  State<IndependentImageBubble> createState() => _IndependentImageBubbleState();
}

class _IndependentImageBubbleState extends State<IndependentImageBubble> {
  Color overlayColor = Colors.transparent;
  bool longPressed = false;
  Icon? stateIcon;

  late final chatProvider =
      Provider.of<ChatMessagesProvider>(context, listen: false);

  late double prefWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // The preferred width of the message bubble
    prefWidth = MediaQuery.of(context).size.width * .75;
  }

  /// Updates the overlayColor value and
  /// switches the longPressed value
  void update() => setState(() {
        longPressed = !longPressed;
        overlayColor = longPressed
            ? AppColors.bubbleColor.withOpacity(0.15)
            : Colors.transparent;
      });

  void onLongTapMessage() {
    /*
    update();
    chatProvider.onLongTapMessage(widget.message);
    chatProvider.updateMLPValue();
     */
  }

  void onTapMessage() {
    /*
    if (chatProvider.isMessageLongPressed) {
      update();
      chatProvider.onLongTapMessage(widget.message);
    }
    chatProvider.updateMLPValue();
     */
  }

  void updateReply() {} //chatProvider.updateReplyBySwipe(widget.message);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapMessage,
      onDoubleTap: onLongTapMessage,
      child: SwipeTo(
        offsetDx: 0.25,
        rightSwipeWidget: const Padding(
          padding: EdgeInsets.only(left: 25),
          child: Icon(
            Icons.reply_rounded,
            size: 30,
            color: AppColors.primaryColor,
          ),
        ),
        child: Container(
          color: overlayColor,
          child: Align(
            alignment: widget.isSender ? Alignment.topRight : Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: CustomPaint(
                painter: BubblePainter(
                  color: widget.color,
                  alignment:
                      widget.isSender ? Alignment.topRight : Alignment.topLeft,
                  tail: false,
                ),
                child: ClipRect(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: prefWidth,
                    ),
                    margin: widget.isSender
                        ? const EdgeInsets.fromLTRB(1, 4, 14, 2)
                        : const EdgeInsets.fromLTRB(9, 3, 3, 0.5),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(11.5),
                                  ),
                                  child: ImagePreview(
                                    media: [widget.media],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 7,
                          right: 4,
                          child: _getFrostedWidget(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: widget.isSender ? 4 : 0,
            //left: 3,
          ),
          child: Text(
            widget.timeSent,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ),
        if (widget.isSender) SizedBox(child: stateIcon),
      ],
    );
  }

  Widget _getFrostedWidget() {
    return SizedBox(
      child: _getRowWidget(),
    ).frosted(
        blur: 0,
        frostColor: Colors.transparent,
        width: 55,
        height: 18,
        borderRadius: const BorderRadius.all(Radius.circular(12))
        //padding: const EdgeInsets.only(left: 10),
        );
  }
}
