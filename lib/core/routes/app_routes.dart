import 'package:flutter/material.dart';
import 'package:space_anywhere/presentation/pages/drawer_pages/comparison_page.dart';
import 'package:space_anywhere/presentation/pages/drawer_pages/calculator_page.dart';
import 'package:space_anywhere/presentation/pages/drawer_pages/home_page.dart';
import 'package:space_anywhere/presentation/pages/drawer_pages/quiz_page.dart';
import 'package:space_anywhere/presentation/pages/drawer_pages/wallpaper_page.dart';

class AppRoutes {
  static final pages = const [
    HomePage(),
    QuizPage(),
    ComparisonPage(),
    WallpaperPage(),
    CalculatorPage()
  ];

  static final pageNames = const [
    "Home",
    "Quiz",
    "Metrícas",
    "Wallpaper",
    "Calculadora"
  ];

  static Route<dynamic> getRoute({required Widget page, Offset begin = const Offset(1.0, 0.0)}) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child
        );
      }
    );
  }
}
