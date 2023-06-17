import 'package:blur/blur.dart';
import 'package:conta/res/components/reply_bubble.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models/message.dart';
import '../../view_model/chat_messages_provider.dart';
import '../color.dart';
import 'bubble_painter.dart';
import 'image_preview/image_preview.dart';

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
    required this.color,
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
  Color stateIconColor = Colors.transparent;

  late TextPainter painter;
  late TextPainter timePainter;
  late double prefWidth;
  late bool hasReply;
  late bool hasMedia;
  late bool hasContent;

  @override
  void initState() {
    super.initState();

    //chatProvider.setResetOverlayColorCallback(resetOverlayColor);

    replyMessage = widget.message.replyMessage;
    hasContent = widget.message.content.isNotEmpty;

    hasReply = widget.message.reply &&
        widget.message.replyMessage != null &&
        widget.message.replySenderId != null;

    hasMedia = widget.message.media != null;

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

/*
void resetOverlayColor() {
    // Todo : There is an error with this
    setState(() {
      overlayColor = Colors.transparent;
      longPressed = false;
    });
  }

 */

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
    stateTick = true;
    stateIconColor =
        hasMedia && !hasContent ? Colors.white : AppColors.stateIconColor;

    // Update the state icon depending on the state of 'seen' and 'sent'
    if (widget.message.sent) {
      stateIcon = sentIcon(stateIconColor);
    } else if (widget.message.seen) {
      stateIcon = seenIcon(stateIconColor);
    } else {
      stateIcon = offlineIcon(stateIconColor);
    }

    return GestureDetector(
      onTap: onTapMessage,
      onDoubleTap: onLongTapMessage,
      child: SwipeTo(
        offsetDx: 0.25,
        onRightSwipe: () => updateReply(),
        rightSwipeWidget: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: replyIcon(),
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
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                child: CustomPaint(
                  painter: BubblePainter(
                    color: widget.color,
                    alignment: widget.isSender
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    tail: widget.tail,
                  ),
                  child: ClipRect(
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
                        width = lines == 0 &&
                                painter.width < (prefWidth - addedWidth)
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

                        return Container(
                          constraints: BoxConstraints(
                            minWidth: width,
                            minHeight: height,
                            maxWidth: prefWidth,
                          ),
                          margin: getBubblePadding(
                            widget.isSender,
                            stateTick,
                            hasMedia,
                            replyMessage != null,
                            hasContent,
                          ),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: stateTick
                                      ? (replyMessage != null ? 0 : 4)
                                      : 4,
                                ),
                                child: Consumer<ChatMessagesProvider>(
                                    builder: (_, data, child) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (hasReply)
                                        ReplyBubble(
                                          replyMessage:
                                              widget.message.replyMessage!,
                                          messageSender:
                                              widget.message.replySenderId! ==
                                                      data.currentUser!.uid
                                                  ? 'You'
                                                  : data.currentChat!.username,
                                        ),
                                      if (hasMedia)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 3),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(11.5),
                                            ),
                                            child: ImagePreview(
                                              chatId: data.currentChat!.chatId!,
                                              sender: widget.isSender
                                                  ? 'You'
                                                  : data.currentChat!.username,
                                              timeSent:
                                                  widget.message.timestamp,
                                              media: widget.message.media!,
                                            ),
                                          ),
                                        ),
                                      if (hasContent)
                                        Padding(
                                          padding: getContentPadding(
                                              replyMessage != null, hasMedia),
                                          child: Text(
                                            widget.message.content,
                                            style: widget.textStyle,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                    ],
                                  );
                                }),
                              ),
                              if (stateIcon != null)
                                Positioned(
                                  bottom: hasContent ? 0 : 7,
                                  right: hasContent ? 5 : 4,
                                  child: hasMedia && !hasContent
                                      ? _getFrostedWidget(
                                          isSender: widget.isSender,
                                        )
                                      : _getRowWidget(),
                                )
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
          ),
          child: Text(
            widget.timeSent,
            style: widget.timeStyle.copyWith(
              color: hasMedia && !hasContent
                  ? Colors.white
                  : widget.timeStyle.color,
            ),
          ),
        ),
        if (widget.isSender) SizedBox(child: stateIcon),
      ],
    );
  }

  Widget _getFrostedWidget({bool isSender = true}) {
    return SizedBox(
      child: _getRowWidget(),
    ).frosted(
        blur: 0,
        frostColor: Colors.transparent,
        width: isSender ? 75 : 55,
        height: 18,
        borderRadius: const BorderRadius.all(Radius.circular(12)));
  }
}
