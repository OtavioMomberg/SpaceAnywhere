import 'package:space_anywhere/models/api_models/wallpaper_model.dart';
import 'package:space_anywhere/repositories/wallpaper_repository_http.dart';

class WallpaperController {
  final WallpaperRepositoryHttp _wallpaperRepositoryHttp;

  WallpaperController(this._wallpaperRepositoryHttp);

  String? _errorGetWallpaper;

  String? get getErrorWallpaper => _errorGetWallpaper;

  List<WallpaperModel?> _wallpaperModel = [];

  List<WallpaperModel?> get getWallpaperModel => _wallpaperModel;

  Future<void> onGetWallpaper({required int offset}) async {
    _errorGetWallpaper = null;
    try {
      final response = await _wallpaperRepositoryHttp.getWallpaper(offset: offset);

      if (response.isNotEmpty) { _wallpaperModel = response; }
      
    } catch(error) {
      _errorGetWallpaper = error.toString();
    }
  }
}