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
  final double? mini;
  final Color color;

  const StatItem({
    required this.value,
    required this.target,
    required this.format,
    required this.average,
    required this.color,
    this.mini,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 8),
        child: Stack(
          children: [
            Builder(builder: (context) {
              final main = NeumorphicProgress(
                percent: min(1, value / target),
                height: 16,
                style: ProgressStyle(
                  depth: 4,
                  border: lightBorder,
                  accent: color,
                  variant: color,
                ),
              );
              if (mini == null) {
                return main;
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: NeumorphicProgress(
                      percent: min(1, (mini ?? 1) / value),
                      height: 4,
                      style: const ProgressStyle(
                        depth: 4,
                        border: lightBorder,
                        accent: Colors.white,
                        variant: Colors.white,
                      ),
                    ),
                  ),
                  main,
                ],
              );
            }),
            Padding(
              padding: EdgeInsets.only(
                  top: mini == null ? 22 : 26, left: 16, right: 16),
              child: NeumorphicProgress(
                percent: min(1, (average > target ? target : average) / target),
                height: 4,
                style: ProgressStyle(
                  depth: 1,
                  border: lightBorder,
                  variant: color.withOpacity(0),
                  accent: color,
                ),
              ),
            ),
            if (average > target)
              Padding(
                padding: EdgeInsets.only(
                    top: mini == null ? 27 : 31, left: 16, right: 16),
                child: Transform(
                  transform: Matrix4.rotationY(pi),
                  alignment: Alignment.center,
                  child: NeumorphicProgress(
                    percent: min(1, (average - target) / target),
                    height: 4,
                    style: ProgressStyle(
                      lightSource: LightSource.bottomRight,
                      depth: 1,
                      border: lightBorder,
                      variant: color,
                      accent: color,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
