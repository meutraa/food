import 'dart:math';

import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final double fats;
  final double carbs;
  final double proteins;
  final double? maxi;
  final bool drawDots;
  final Color? fillColor;
  final double width;

  final dotPaint = Paint()..color = Colors.white;

  CurvePainter({
    required this.fats,
    required this.carbs,
    required this.proteins,
    this.drawDots = true,
    this.width = 1.0,
    this.fillColor,
    this.maxi,
  });

  Path drawPath(Size size) {
    final w = size.width;
    final h = size.height;
    final hm = h / 2;
    final wm = w / 2;

    var f = fats;
    var p = proteins;
    var c = carbs;

    // debugPrint('$f, $p, $c');
    // debugPrint('$hm, $wm');

    // hm is the max value of fat/etc
    // say the max val is 300, and we have 100 pixels to fit it in
    // we want to get r = max/hm = 3, then divide all by r
    final double maxval = max(max(f, c), p);
    if (maxi == null && maxval > hm) {
      final r = maxval / hm;
      f /= r;
      p /= r;
      c /= r;
    } else if (maxi == null) {
      final r = hm / maxval;
      f *= r;
      p *= r;
      c *= r;
    }

    // debugPrint('$f, $p, $c');
    // f p and c are now in pixel offsets from the center point hm, wm

    const rads = 0.523599;
    final cv = c * sin(rads);
    final ch = c * cos(rads);
    final pv = p * sin(rads);
    final ph = p * cos(rads);

    final path = Path()
      ..moveTo(
        wm,
        hm - f,
      )
      ..quadraticBezierTo(
        wm - (0.5 * ph),
        hm - (0.5 * ((-cv + f) / 2)),
        wm - ph,
        hm + pv,
      )
      ..quadraticBezierTo(
        wm + (0.5 * ((-ph + ch) / 2)),
        hm + (0.5 * ((cv + pv) / 2)),
        wm + ch,
        hm + cv,
      )
      ..quadraticBezierTo(
        wm + (0.5 * ch),
        hm - (0.5 * ((cv + f) / 2)),
        wm,
        hm - f,
      );
    if (drawDots) {
      path
        ..addOval(
          Rect.fromCenter(
            center: Offset(
              wm - ph,
              hm + pv,
            ),
            width: 4,
            height: 4,
          ),
        )
        ..addOval(
          Rect.fromCenter(
            center: Offset(
              wm + ch,
              hm + cv,
            ),
            width: 4,
            height: 4,
          ),
        )
        ..addOval(
          Rect.fromCenter(
            center: Offset(
              wm,
              hm - f,
            ),
            width: 4,
            height: 4,
          ),
        );
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = drawPath(size);
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      // Draw the center dot
      final grid = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: 2,
            height: 2,
          ),
        );

      canvas.drawPath(grid, dotPaint);
      return;
    }

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter o) {
    if (o is CurvePainter) {
      if (o.fats == fats &&
          o.maxi == maxi &&
          o.proteins == proteins &&
          o.carbs == carbs) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
