import 'package:flutter/material.dart';
import 'dart:ui';

class StarPainter extends CustomPainter {
  final List<Offset> positions;
  const StarPainter({required this.positions});

  @override
  void paint(Canvas canvas, Size size) {
    final paintMethod = Paint(); 
    paintMethod.strokeWidth = 3;
    paintMethod.strokeCap = StrokeCap.round;
    paintMethod.color = const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.3);

    canvas.drawPoints(PointMode.points, positions, paintMethod);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}