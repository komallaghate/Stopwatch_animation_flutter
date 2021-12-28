import 'package:flutter/material.dart';

class ClockHand extends StatelessWidget {
  const ClockHand(
      {Key? key,
      required this.rotationZangle,
      required this.handThickness,
      required this.handLength,
      required this.color})
      : super(key: key);
  final double rotationZangle;
  final double handThickness;
  final double handLength;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.topCenter,
      transform: Matrix4.identity()
        ..translate(-handThickness / 2, 0.0, 0.0)
        ..rotateZ(rotationZangle),
      child: Stack(children: [
        Container(
          height: handLength,
          width: handThickness,
          color: color,
        ),
        Positioned(
            // top: handLength,
            bottom: handLength - 10,
            child: CircleAvatar(
              radius: 10,
              foregroundColor: Colors.white,
              backgroundColor: Colors.white,
            ))
      ]),
    );
  }
}
