import 'package:flutter/material.dart';
import 'package:space_anywhere/themes/stars_draw/star_painter.dart';

class StarPainterWidget extends StatelessWidget {
  final List<Offset> stars;
  final Widget? child;
  const StarPainterWidget({required this.stars, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: StarPainter(positions: stars),
      child: child
    );
  }
}