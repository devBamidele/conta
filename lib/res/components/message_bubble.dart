import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  final String id;
  final bool isSender;
  final String text;
  final bool tail;
  final int index;
  final Color color;
  final bool sent;
  final bool seen;
  final String timeSent;
  final TextStyle textStyle;
  final TextStyle timeStyle;

  const MessageBubble({
    Key? key,
    required this.id,
    required this.isSender,
    required this.index,
    required this.text,
    required this.sent,
    required this.seen,
    required this.timeSent,
    this.color = Colors.white70,
    this.tail = true,
    this.textStyle = const TextStyle(
      color: Colors.black87,
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

  double height = 0;
  double width = 0;
  double addedSpacing = 0;
  int lines = 0;
  bool stateTick = false;
  bool messageTapped = false;
  Icon? stateIcon;
  Color overlayColor = Colors.transparent;
  late TextPainter painter;
  late TextPainter timePainter;
  late double prefWidth;

  @override
  void initState() {
    super.initState();

    painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.textStyle),
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
    prefWidth = MediaQuery.of(context).size.width * .75;
  }

  void onVisibilityChanged(VisibilityInfo info) {
    if (mounted) {
      setState(() {
        if (!widget.seen && info.visibleFraction > 0.8 && !widget.isSender) {
          chatProvider.updateMessageSeen(widget.id);
        }
      });
    }
  }

  void onLongTapMessage() {
    setState(() {
      messageTapped = !messageTapped;
      overlayColor = messageTapped
          ? AppColors.bubbleColor.withOpacity(0.15)
          : Colors.transparent;
    });
  }

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    if (widget.sent) {
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
    if (widget.seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.black45,
      );
    }

    return GestureDetector(
      onTap: onLongTapMessage,
      onLongPress: onLongTapMessage,
      child: VisibilityDetector(
        key: widget.key!,
        onVisibilityChanged: onVisibilityChanged,
        child: Container(
          color: overlayColor,
          child: Align(
            alignment: widget.isSender ? Alignment.topRight : Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: CustomPaint(
                painter: BubblePainter(
                  color: widget.color,
                  alignment:
                      widget.isSender ? Alignment.topRight : Alignment.topLeft,
                  tail: widget.tail,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    lines = painter.width ~/ prefWidth;

                    addedSpacing = timePainter.width + 42;

                    width =
                        lines == 0 && painter.width < (prefWidth - addedSpacing)
                            ? painter.width + addedSpacing
                            : 0;

                    height = width == 0
                        ? lines == 0
                            ? 2 * painter.height
                            : lines * painter.height
                        : 0;

                    if (height != 0 && lines == 0) {
                      width = painter.width +
                          (prefWidth - painter.width).clamp(0, 30);
                    }
                    return Container(
                      constraints: BoxConstraints(
                        minWidth: width,
                        minHeight: height,
                        maxWidth: prefWidth,
                      ),
                      margin: widget.isSender
                          ? stateTick
                              ? const EdgeInsets.fromLTRB(7, 7, 14, 7)
                              : const EdgeInsets.fromLTRB(7, 7, 17, 7)
                          : const EdgeInsets.fromLTRB(17, 7, 7, 7),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: stateTick
                                ? const EdgeInsets.only(left: 4)
                                : const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              widget.text,
                              style: widget.textStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          stateIcon != null
                              ? Positioned(
                                  bottom: 0,
                                  right: 0,
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
    );
  }
}
