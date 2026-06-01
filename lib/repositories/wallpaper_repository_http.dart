import 'package:space_anywhere/models/api_models/wallpaper_model.dart';

abstract class WallpaperRepositoryHttp {
  Future<List<WallpaperModel?>> getWallpaper({required int offset});
}