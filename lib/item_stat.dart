import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'style.dart';

class StatItem extends StatelessWidget {
  final String Function(double) format;
  final double value;
  final double target;
  final Color color;

  const StatItem({
    required this.value,
    required this.target,
    required this.format,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 8),
        child: NeumorphicProgress(
          percent: min(1, value / target),
          height: 16,
          style: ProgressStyle(
            depth: 4,
            border: lightBorder,
            accent: color,
            variant: color,
          ),
        ),
      );
}
