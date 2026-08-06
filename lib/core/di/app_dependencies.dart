import 'package:http/http.dart';
import 'package:space_anywhere/controllers/curiosity_controller.dart';
import 'package:space_anywhere/controllers/question_controller.dart';
import 'package:space_anywhere/controllers/wallpaper_controller.dart';
import 'package:space_anywhere/repositories/implementations/curiosity_implementation_http.dart';
import 'package:space_anywhere/repositories/implementations/question_inplementation_http.dart';
import 'package:space_anywhere/repositories/implementations/wallpaper_implementation_http.dart';
import 'package:space_anywhere/services/db_service.dart';

class AppDependencies {
  static final db = DatabaseService.instance();

  static final Client _client = Client();

  static CuriosityController get curiosityController => CuriosityController(
    CuriosityImplementationHttp(client: _client),
  );

  static QuestionController get questionController => QuestionController(
    QuestionInplementationHttp(client: _client),
  );

  static WallpaperController get wallpaperController => WallpaperController(
    WallpaperImplementationHttp(client: _client),
  );
}