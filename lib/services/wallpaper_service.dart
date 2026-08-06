import 'package:space_anywhere/controllers/wallpaper_controller.dart';
import 'package:space_anywhere/services/internet_service.dart';
import 'package:space_anywhere/core/utils/image_cache_service.dart';

class WallpaperService {
  late InternetService _internet;
  int _offset = 0;
  String _error = "";
  Future<void> Function()? _function;

  final WallpaperController wallpaperController;

  WallpaperService({
    required this.wallpaperController
  });

  //WallpaperController get wallpaperController => _wallpaperController;
  InternetService get internet => _internet;
  int get offset => _offset;
  String get error => _error;

  set generalError(String value) => _error = value;

  Future<void> getFunction({required Future<void> Function() func}) async {
    _function = func;
  }

  Future<void> initializeInternetInstance() async {
    if (_function == null) {
      throw Exception("É necessário receber a função service.");
    }

    _internet = InternetService.withoutFunctionParameter(function: _function!);
  }

  void updateOffset({required int newOffset}) => _offset = newOffset;

  bool checkImageCache() {
    if (ImageCacheService.wallpapers != null) {
      _internet.updateInternetStatus(status: true);
      _internet.updateAPIStatus(status: true);
      return false;
    }
    return true;
  }

  Future<void> getImages() async {
    await _internet.hasInternet();

    if (!_internet.checkInternet) {
      return;
    }

    await _internet.isApiAwake();

    if (!_internet.checkAPI) {
      return;
    }

    await wallpaperController.onGetWallpaper(offset: _offset);

    if (wallpaperController.getErrorWallpaper == null) {
      ImageCacheService.wallpapers = wallpaperController.getWallpaperModel;
    } else {
      _error = wallpaperController.getErrorWallpaper!;
    }
  }
}
