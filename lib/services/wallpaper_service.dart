import 'package:http/http.dart';
import 'package:space_anywhere/controllers/wallpaper_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/repositories/implementations/wallpaper_implementation_http.dart';
import 'package:space_anywhere/utils/image_cache_service.dart';

class WallpaperService {
  final WallpaperController _wallpaperController = WallpaperController(WallpaperImplementationHttp(Client()));
  bool _checkInternet = false;
  bool _checkAPI = false;
  int _offset = 0;
  String _error = "";

  // getters
  WallpaperController get wallpaperController => _wallpaperController;
  bool get checkInternet => _checkInternet;
  bool get checkAPI => _checkAPI;
  int get offset => _offset;
  String get error => _error;

  void updateOffset({required int newOffset}) => _offset = newOffset;

  static final _instance = WallpaperService._();
  WallpaperService._();

  factory WallpaperService.instance() => _instance;

  bool checkImageCache() {
    if (ImageCacheService.wallpapers != null) {
      _checkInternet = true;
      _checkAPI = true;
      return false;
    }
    return true;
  }
  
  Future<void> getImages() async {
    _checkInternet = await Internet.hasInternet();

    if (!_checkInternet) {
      return;
    }

    _checkAPI = await Internet.isApiAwake();

    if (!_checkAPI) {
      return;
    }

    await _wallpaperController.onGetWallpaper(offset: _offset);

    if (_wallpaperController.getErrorWallpaper == null) {
      ImageCacheService.wallpapers = _wallpaperController.getWallpaperModel;
    } else {
      _error = _wallpaperController.getErrorWallpaper!;
    }
  }
}