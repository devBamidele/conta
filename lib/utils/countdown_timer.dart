import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int durationInSeconds;
  final TextStyle? textStyle;
  final VoidCallback? onFinished;
  final Function(Duration)? onTimerTick;

  const CountdownTimer({
    super.key,
    required this.durationInSeconds,
    this.textStyle,
    this.onFinished,
    this.onTimerTick,
  });

  @override
  State<CountdownTimer> createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late int _durationInSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _durationInSeconds = widget.durationInSeconds;
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void restartTimer() {
    setState(() {
      _durationInSeconds = widget.durationInSeconds;
    });
    _timer?.cancel();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _durationInSeconds--;
      });
      if (_durationInSeconds <= 0) {
        _timer?.cancel();
        if (widget.onFinished != null) {
          widget.onFinished!();
        }
      } else if (widget.onTimerTick != null) {
        widget.onTimerTick!(Duration(seconds: _durationInSeconds));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_durationInSeconds ~/ 60).toString();
    if (_durationInSeconds < 60) {
      minutes = '';
    } else {
      minutes = '${minutes.padLeft(2, '0')}:';
    }
    String seconds = (_durationInSeconds % 60).toString().padLeft(2, '0');
    String timerText = minutes + seconds;

    return Text(
      timerText,
      style: widget.textStyle,
    );
  }
}
