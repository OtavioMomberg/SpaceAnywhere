import 'package:flutter/material.dart';
import 'dart:math';

class StarsPositions {
  final List<Offset> stars;
  const StarsPositions({required this.stars});

  static const int starQuantity = 200;
  static final random = Random();

  List<Offset> getStarPositions(Size size) {
    final starPositions = stars
      .map((e) => Offset(e.dx * size.width, e.dy * (size.height - kToolbarHeight)))
      .toList();

    return starPositions;
  }
}
