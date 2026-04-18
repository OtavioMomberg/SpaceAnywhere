import 'package:space_anywhere/models/api_models/wallpaper_model.dart';
import 'package:space_anywhere/repositories/wallpaper_repository_http.dart';

class WallpaperController {
  final WallpaperRepositoryHttp wallpaperRepositoryHttp;

  WallpaperController(this.wallpaperRepositoryHttp);

  String? _errorGetWallpaper;

  String? get getErrorWallpaper => _errorGetWallpaper;

  bool _isLoading = true;

  bool get getIsLoading => _isLoading;

  WallpaperModel? _wallpaperModel;

  WallpaperModel? get getWallpaperModel => _wallpaperModel;

  Future<void> onGetWallpaper(int offset) async {
    _errorGetWallpaper = null;
    _isLoading = true;
    try {
      final response = await wallpaperRepositoryHttp.getWallpaper(offset);

      if (response != null) _wallpaperModel = response;
      
    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorGetWallpaper = split[split.length-2];
    }
    _isLoading = false;
  }
}