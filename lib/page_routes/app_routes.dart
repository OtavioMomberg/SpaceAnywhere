import 'package:space_anywhere/pages/drawer_pages/comparison_page.dart';
import 'package:space_anywhere/pages/drawer_pages/calculator_page.dart';
import 'package:space_anywhere/pages/drawer_pages/home_page.dart';
import 'package:space_anywhere/pages/drawer_pages/quiz_page.dart';
import 'package:space_anywhere/pages/drawer_pages/wallpaper_page.dart';

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
