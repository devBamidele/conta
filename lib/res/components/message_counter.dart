import 'package:flutter/material.dart';

class MessageCounter extends StatefulWidget {
  final int count;

  const MessageCounter({Key? key, required this.count}) : super(key: key);

  @override
  State<MessageCounter> createState() => _MessageCounterState();
}

class _MessageCounterState extends State<MessageCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(MessageCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Text(
        '${widget.count}',
        key: ValueKey<int>(widget.count),
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}
