import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../color.dart';

/// Generates a custom `Animation<Color?>` for the valueColor of an animation.
Animation<Color?> customValueColorAnim() {
  // Create an AnimationController for managing the animation
  final controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: TickerProviderImpl(),
  );

  // Define the color transitions using TweenSequence
  final animation = TweenSequence<Color?>(
    [
      TweenSequenceItem(
        tween: ColorTween(
          begin: AppColors.mainRingColor,
          end: AppColors.secondRingColor,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: AppColors.secondRingColor,
          end: AppColors.thirdRingColor,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: AppColors.thirdRingColor,
          end: AppColors.mainRingColor,
        ),
        weight: 1,
      ),
      // Add more color transitions if needed
    ],
  ).animate(controller);

  // Repeat the animation in a forward and reverse direction
  controller.repeat(reverse: true);

  return animation;
}

/// Custom implementation of TickerProvider for creating the Ticker
class TickerProviderImpl extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
