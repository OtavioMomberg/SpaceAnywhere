import 'package:space_anywhere/pages/comparison_page.dart';
import 'package:space_anywhere/pages/calculator_page.dart';
import 'package:space_anywhere/pages/home_page.dart';
import 'package:space_anywhere/pages/quiz_page.dart';
import 'package:space_anywhere/pages/wallpaper_page.dart';

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
}
