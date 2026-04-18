import 'package:space_anywhere/pages/comparison_page.dart';
import 'package:space_anywhere/pages/credit_page.dart';
import 'package:space_anywhere/pages/home_page.dart';
import 'package:space_anywhere/pages/quiz_page.dart';
import 'package:space_anywhere/pages/wallpaper_page.dart';

class AppRoutes {
  static final pages = const [
    HomePage(), 
    QuizPage(),
    ComparisonPage(),
    WallpaperPage(),
    CreditPage()
  ];

  static final pageNames = const [
    "Home",
    "Quiz",
    "Metrícas",
    "Wallpaper",
    "Créditos"
  ];
}