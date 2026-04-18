import 'package:space_anywhere/models/api_models/wallpaper_model.dart';

abstract class WallpaperRepositoryHttp {
  Future<WallpaperModel?> getWallpaper(int offset);
}