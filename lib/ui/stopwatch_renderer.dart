import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stopwatch_flutter/ui/clock_hand.dart';
import 'package:stopwatch_flutter/ui/clock_markers.dart';

import 'package:stopwatch_flutter/ui/elapsed_time_text.dart';

class StopWatchRenderer extends StatelessWidget {
  final Duration elapsed;
  final double radius;

  const StopWatchRenderer(
      {Key? key, required this.elapsed, required this.radius})
      : super(key: key);

  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < 240; i++)
          Positioned(
            left: radius,
            top: radius,
            child: ClockSecondsTickMarker(seconds: i, radius: radius),
          ),
        for (var i = 0; i < 60; i++)
          Positioned(
            left: radius,
            top: radius - 70,
            child:
                InnerClockSecondsTickMarker(seconds: i, radius: radius / 3.5),
          ),
        for (var i = 5; i <= 60; i += 5)
          Positioned(
              top: radius,
              left: radius,
              child: ClockTextMarker(
                value: i,
                maxValue: 60,
                radius: radius,
              )),
        for (var i = 5; i <= 30; i += 5)
          Positioned(
              top: radius - 65,
              left: radius,
              child: InnerClockTextMarker(
                value: i,
                maxValue: 30,
                radius: radius / 2.8,
              )),
        Positioned(
          left: radius,
          top: radius - 70,
          child: ClockHand(
              handLength: radius / 3.5,
              handThickness: 2,
              rotationZangle: pi + (2 * pi / 60000) * elapsed.inMilliseconds,
              color: Colors.yellow.withOpacity(0.7)),
        ),
        Positioned(
          left: radius,
          top: radius,
          child: ClockHand(
              handLength: radius,
              handThickness: 2,
              rotationZangle: pi + (2 * pi / 60000) * elapsed.inMilliseconds,
              color: Colors.yellow.withOpacity(0.7)),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: radius * 1.3,
          child: ElapsedTimeText(
            elapsed: elapsed,
          ),
        ),
      ],
    );
  }
}
