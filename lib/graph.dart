import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'stats_painter.dart';

class ColoredStats extends StatelessWidget {
  final double fats;
  final double carbs;
  final double proteins;
  final double? maxi;

  const ColoredStats({
    required this.fats,
    required this.carbs,
    required this.proteins,
    this.maxi,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ShaderMask(
        shaderCallback: (rect) => const SweepGradient(
          startAngle: 3 * pi / 2,
          endAngle: 7 * pi / 2,
          tileMode: TileMode.repeated,
          colors: [
            Colors.yellow,
            Colors.pinkAccent,
            Colors.orangeAccent,
            Colors.yellow
          ],
        ).createShader(rect),
        child: CustomPaint(
          painter: CurvePainter(
            maxi: maxi,
            fats: fats,
            carbs: carbs,
            proteins: proteins,
          ),
        ),
      );
}
