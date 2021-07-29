import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
        child: Stack(
          children: [
            Neumorphic(
              style: NeumorphicStyle(
                depth: 8,
                boxShape: const NeumorphicBoxShape.stadium(),
                shadowLightColor: Colors.lightBlue.shade300,
                lightSource: LightSource.top,
              ),
              child: const SizedBox(
                width: 320,
                height: 24,
              ),
            ),
            Neumorphic(
              style: const NeumorphicStyle(
                depth: -8,
                lightSource: LightSource.top,
                intensity: 1,
                boxShape: NeumorphicBoxShape.stadium(),
                border: NeumorphicBorder(
                  color: Color(0x33000000),
                  width: 1,
                ),
              ),
              child: Container(
                width: 320,
                height: 24,
                color: Colors.white,
              ),
            ),
            Container(
              width: min(320, 320 * value / target),
              height: 24,
              decoration: BoxDecoration(
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.33),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 0), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Center(
                child: Text(
                  format(value),
                  style: TextStyle(
                    fontSize: 11,
                    color: color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
