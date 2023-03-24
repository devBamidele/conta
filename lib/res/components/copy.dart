/*
LayoutBuilder(
  builder: (BuildContext context, BoxConstraints constraints) {
    String text = 'This is the string';
    TextStyle style = TextStyle(fontSize: 16);

    TextSpan span = TextSpan(text: text, style: style);
    TextPainter painter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    painter.layout(maxWidth: constraints.maxWidth);
    double width = painter.width;

    return Container(
      width: width,
      child: Text(text, style: style),
    );
  },
);
In this example, we use the LayoutBuilder widget to get the maximum width available for the Text widget, and then we create a TextPainter object with the same text and style as before.

Next, we call painter.layout(maxWidth: constraints.maxWidth) to calculate the layout constraints and width of the text, using the maximum width available from the LayoutBuilder widget.

Finally, we retrieve the width of the text by calling painter.width, and use it to set the width of a Container widget that contains the Text widget with the same text and style.

Note that this approach still involves creating a TextPainter object, but it's done implicitly inside the Text widget. The advantage of using this method is that you don't need to manually calculate the layout constraints, as the LayoutBuilder widget handles that for you.

I hope this helps! Let me know if you have any other questions or if there's anything else I can do for you.



 log('${length % prefWidth}');
    if (text.isNotEmpty) {
      if (length % prefWidth - 60 < prefWidth) {
        width = length;
      } else {
        height = (length ~/ prefWidth) * 50;
        height += 60;
      }
    }


 */
