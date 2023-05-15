import 'package:conta/res/components/reply_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/message.dart';
import '../../view_model/chat_messages_provider.dart';
import '../color.dart';
import 'bubble_painter.dart';

///iMessage's chat bubble type
///
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///chat bubble [TextStyle] can be customized using [textStyle]

class MessageBubble extends StatefulWidget {
  final bool isSender;
  final bool tail;
  final int index;
  final Color color;
  final String timeSent;
  final TextStyle textStyle;
  final TextStyle timeStyle;
  final Message message;

  const MessageBubble({
    Key? key,
    required this.isSender,
    required this.index,
    required this.timeSent,
    required this.message,
    this.color = Colors.white70,
    this.tail = true,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    this.timeStyle = const TextStyle(
      fontSize: 10,
      color: Colors.black45,
    ),
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late final chatProvider =
      Provider.of<ChatMessagesProvider>(context, listen: false);

  late String? replyMessage;

  double height = 0;
  double width = 0;
  double addedWidth = 0;
  double addedHeight = 0;
  int lines = 0;
  bool stateTick = false;
  Icon? stateIcon;
  Color overlayColor = Colors.transparent;
  bool longPressed = false;
  late TextPainter painter;
  late TextPainter timePainter;
  late double prefWidth;

  @override
  void initState() {
    super.initState();

    chatProvider.setResetOverlayColorCallback(resetOverlayColor);

    replyMessage = widget.message.replyMessage;

    painter = TextPainter(
      text: TextSpan(text: widget.message.content, style: widget.textStyle),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: double.infinity);

    timePainter = TextPainter(
      text: TextSpan(text: widget.timeSent, style: widget.timeStyle),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    timePainter.layout(maxWidth: double.infinity);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // The preferred width of the message bubble
    prefWidth = MediaQuery.of(context).size.width * .75;
  }

  void onVisibilityChanged(VisibilityInfo info) {
    if (mounted) {
      setState(() {
        if (!widget.message.seen &&
            info.visibleFraction > 0.8 &&
            !widget.isSender) {
          chatProvider.updateMessageSeen(widget.message.id);
        }
      });
    }
  }

  /// Updates the overlayColor value and
  /// switches the longPressed value
  void update() => setState(() {
        longPressed = !longPressed;
        overlayColor = longPressed
            ? AppColors.bubbleColor.withOpacity(0.15)
            : Colors.transparent;
      });

  void resetOverlayColor() {
    // Todo : There is an error with this
    setState(() {
      overlayColor = Colors.transparent;
      longPressed = false;
    });
  }

  void onLongTapMessage() {
    update();
    chatProvider.onLongTapMessage(widget.message);
    chatProvider.updateMLPValue();
  }

  void onTapMessage() {
    if (chatProvider.isMessageLongPressed) {
      update();
      chatProvider.onLongTapMessage(widget.message);
    }
    chatProvider.updateMLPValue();
  }

  void updateReply() => chatProvider.updateReplyBySwipe(widget.message);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    if (widget.message.sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 14,
        color: Colors.black45,
      );
    } else {
      stateTick = true;
      stateIcon = const Icon(
        Icons.wifi_off_rounded,
        size: 14,
        color: Colors.black45,
      );
    }
    if (widget.message.seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.black45,
      );
    }

    return GestureDetector(
      onTap: onTapMessage,
      onDoubleTap: onLongTapMessage,
      child: SwipeTo(
        offsetDx: 0.25,
        onRightSwipe: () => updateReply(),
        rightSwipeWidget: const Padding(
          padding: EdgeInsets.only(left: 25),
          child: Icon(
            Icons.reply_rounded,
            size: 30,
            color: AppColors.primaryColor,
          ),
        ),
        child: VisibilityDetector(
          key: widget.key!,
          onVisibilityChanged: onVisibilityChanged,
          child: Container(
            color: overlayColor,
            child: Align(
              alignment:
                  widget.isSender ? Alignment.topRight : Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: CustomPaint(
                  painter: BubblePainter(
                    color: widget.color,
                    alignment: widget.isSender
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    tail: widget.tail,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      lines = painter.width ~/ prefWidth;

                      addedWidth = timePainter.width + 40;

                      addedHeight =
                          prefWidth < (painter.width % prefWidth) + addedWidth
                              ? 42
                              : 0;

                      // If lines == 0, then the text can by default (without the timestamp)
                      // fit within a single line of text.
                      width =
                          lines == 0 && painter.width < (prefWidth - addedWidth)
                              ? painter.width + addedWidth
                              : 0;

                      height = width == 0
                          ? lines == 0
                              ? 2 * painter.height
                              : (lines * painter.height) + addedHeight
                          : 0;

                      width = height != 0 && lines == 0
                          ? painter.width +
                              (prefWidth - painter.width).clamp(0, 30)
                          : width;
/*
 if (widget.message.content ==
                          'I said it before and I don\'t mind saying it again') {
                        log('The Height for ${widget.message.content} is $height');
                      }
 */

                      return Container(
                        constraints: BoxConstraints(
                          minWidth: width,
                          minHeight: height,
                          maxWidth: prefWidth,
                        ),
                        margin: widget.isSender
                            ? stateTick
                                ? replyMessage != null
                                    ? const EdgeInsets.fromLTRB(3.5, 3, 13, 7)
                                    : const EdgeInsets.fromLTRB(7, 7, 14, 7)
                                : const EdgeInsets.fromLTRB(7, 7, 17, 7)
                            : replyMessage != null
                                ? const EdgeInsets.fromLTRB(14, 3, 3, 7)
                                : const EdgeInsets.fromLTRB(14, 7, 3, 7),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: stateTick
                                  ? replyMessage != null
                                      ? const EdgeInsets.only(left: 0)
                                      : const EdgeInsets.only(left: 4)
                                  : const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.message.reply &&
                                      widget.message.replyMessage != null &&
                                      widget.message.sender != null)
                                    ReplyBubble(
                                      replyMessage:
                                          widget.message.replyMessage!,
                                      isSender: widget.isSender,
                                      username: widget.message.sender!,
                                    ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: replyMessage != null ? 8 : 0,
                                    ),
                                    child: Text(
                                      widget.message.content,
                                      style: widget.textStyle,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            stateIcon != null
                                ? Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: widget.isSender ? 3 : 5,
                                          ),
                                          child: Text(
                                            widget.timeSent,
                                            style: widget.timeStyle,
                                          ),
                                        ),
                                        Visibility(
                                          visible: widget.isSender,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 6),
                                            child: stateIcon,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    width: 1,
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Todo: Fix layout issues with message bubble
