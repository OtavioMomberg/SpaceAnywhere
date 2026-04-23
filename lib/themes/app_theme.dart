import 'package:flutter/painting.dart';

class AppTheme {
  static final mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [
      Color.fromARGB(255, 38, 46, 139),
      Color.fromARGB(255, 7, 13, 72),
      Color.fromARGB(255, 15, 6, 65)
    ]
  );
}