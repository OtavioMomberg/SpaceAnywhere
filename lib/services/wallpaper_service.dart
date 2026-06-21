import 'package:http/http.dart';
import 'package:space_anywhere/controllers/wallpaper_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/repositories/implementations/wallpaper_implementation_http.dart';
import 'package:space_anywhere/utils/image_cache_service.dart';

class WallpaperService {
  final WallpaperController _wallpaperController = WallpaperController(WallpaperImplementationHttp(Client()));
  final Internet _internet = Internet();
  int _offset = 0;
  String _error = "";

  WallpaperController get wallpaperController => _wallpaperController;
  Internet get internet =>_internet;
  int get offset => _offset;
  String get error => _error;

  void updateOffset({required int newOffset}) => _offset = newOffset;

  static final _instance = WallpaperService._();
  WallpaperService._();

  factory WallpaperService.instance() => _instance;

  bool checkImageCache() {
    if (ImageCacheService.wallpapers != null) {
      _internet.updateInternetStatus(status: true);
      _internet.updateAPIStatus(status: true);
      return false;
    }
    return true;
  }
  
  Future<void> getImages() async {
    await _internet.verifyInternet();

    if (!_internet.checkInternet) {
      return;
    }

    await _internet.verifyAPI();

    if (!_internet.checkAPI) {
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