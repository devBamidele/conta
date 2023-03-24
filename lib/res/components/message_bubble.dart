import 'package:flutter/material.dart';

///iMessage's chat bubble type
///
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///chat bubble [TextStyle] can be customized using [textStyle]

class MessageBubble extends StatelessWidget {
  final bool isSender;
  final String text;
  final bool tail;
  final Color color;
  final bool sent;
  final bool delivered;
  final bool seen;
  final String timeSent;
  final TextStyle textStyle;
  final TextStyle timeStyle;

  const MessageBubble({
    Key? key,
    this.isSender = true,
    required this.text,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    required this.timeSent,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.timeStyle = const TextStyle(
      fontSize: 10,
      color: Colors.black45,
    ),
  }) : super(key: key);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    double prefWidth = MediaQuery.of(context).size.width * .75;
    double height = 0;
    double width = 0;
    double addedSpacing = 0;
    int lines = 0;
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    } else {
      stateTick = true;
      stateIcon = Icon(
        Icons.wifi_off_rounded,
        size: 18,
        color: timeStyle.color,
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.black45,
      );
    }
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: CustomPaint(
          painter: CustomMessageBubble(
            color: color,
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            tail: tail,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final painter = TextPainter(
                text: TextSpan(text: text, style: textStyle),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              );

              final timePainter = TextPainter(
                text: TextSpan(text: timeSent, style: timeStyle),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              );

              painter.layout(maxWidth: constraints.maxWidth);
              timePainter.layout(maxWidth: constraints.maxWidth);

              lines = painter.width ~/ prefWidth;

              addedSpacing = timePainter.width + 42;

              width = lines == 0 && painter.width < (prefWidth - addedSpacing)
                  ? painter.width + addedSpacing
                  : 0;
//
              height = width == 0
                  ? lines == 0
                      ? (lines + 2) * painter.height + 7
                      : (lines + 1) * painter.height - 3
                  : 0;

              if (height != 0 && lines == 0) {
                double diff = (prefWidth - painter.width).clamp(0, 30);
                width = painter.width + diff;
              }
              return Container(
                constraints: BoxConstraints(
                  minWidth: width,
                  minHeight: height,
                  maxWidth: prefWidth,
                ),
                margin: isSender
                    ? stateTick
                        ? const EdgeInsets.fromLTRB(7, 7, 14, 7)
                        : const EdgeInsets.fromLTRB(7, 7, 17, 7)
                    : const EdgeInsets.fromLTRB(17, 7, 7, 7),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: stateTick
                          ? const EdgeInsets.only(left: 4)
                          : const EdgeInsets.only(left: 4, right: 4),
                      child: Text(
                        text,
                        style: textStyle, //
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
                                  padding:
                                      EdgeInsets.only(right: isSender ? 3 : 5),
                                  child: Text(
                                    timeSent,
                                    style: timeStyle,
                                  ),
                                ),
                                Visibility(
                                  visible: isSender,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6),
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
    );
  }
}

///custom painter use to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class CustomMessageBubble extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  CustomMessageBubble({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;
    if (alignment == Alignment.topRight) {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right bubble curve
        path.quadraticBezierTo(
            w - _radius * 1.5, h, w - _radius * 1.5, h - _radius * 0.6);

        /// bottom-right tail curve 1
        path.quadraticBezierTo(w - _radius * 1, h, w, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            w - _radius * 0.8, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right curve
        path.quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);
        // bottom-right tail curve 1
        path.quadraticBezierTo(_radius * .8, h, 0, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            _radius * 1, h, _radius * 1.5, h - _radius * 0.6);

        /// bottom-left bubble curve
        path.quadraticBezierTo(_radius * 1.5, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);

        /// bottom-left curve
        path.quadraticBezierTo(_radius, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
