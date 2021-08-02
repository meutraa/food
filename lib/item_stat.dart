import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'style.dart';

class StatItem extends StatelessWidget {
  final String Function(double) format;
  final double value;
  final double average;
  final double target;
  final Color color;

  const StatItem({
    required this.value,
    required this.target,
    required this.format,
    required this.average,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 8),
        child: Stack(
          children: [
            NeumorphicProgress(
              percent: min(1, value / target),
              height: 16,
              style: ProgressStyle(
                depth: 4,
                border: lightBorder,
                accent: color,
                variant: color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 22, left: 16, right: 16),
              child: NeumorphicProgress(
                percent: min(1, (average > target ? target : average) / target),
                height: 4,
                style: ProgressStyle(
                  depth: 2,
                  border: lightBorder,
                  variant: color.withOpacity(0),
                  accent: color,
                ),
              ),
            ),
            if (average > target)
              Padding(
                padding: const EdgeInsets.only(top: 27, left: 16, right: 16),
                child: NeumorphicProgress(
                  percent: min(1, (average - target) / target),
                  height: 4,
                  style: ProgressStyle(
                    depth: 2,
                    border: lightBorder,
                    variant: color,
                    accent: color,
                  ),
                ),
              ),
          ],
        ),
      );
}
