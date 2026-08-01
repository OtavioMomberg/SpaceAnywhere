import 'package:flutter/material.dart';

class AppTheme {
  static const mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 38, 46, 139),
      Color.fromARGB(255, 7, 13, 72),
      Color.fromARGB(255, 15, 6, 65)
    ]
  );

  static const Color color1 = Color.fromARGB(255, 206, 206, 207);
  static const Color color2 = Color.fromARGB(255, 38, 46, 139);
  static const Color color3 = Color.fromARGB(255, 7, 13, 72);
  static const Color color4 = Color.fromARGB(255, 15, 6, 65);
  static const Color color5 = Color.fromARGB(255, 250, 221, 134);

  static const Color color6 = Colors.white;
  static const Color color7 = Colors.red;
  static const Color color8 = Colors.lightBlueAccent;

  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(12));
}