import 'package:space_anywhere/controllers/wallpaper_controller.dart';
import 'package:space_anywhere/core/di/app_dependencies.dart';
import 'package:space_anywhere/services/internet_service.dart';
import 'package:space_anywhere/core/utils/image_cache_service.dart';

class WallpaperService {
  final WallpaperController _wallpaperController = AppDependencies.wallpaperController;
  late InternetService _internet;
  int _offset = 0;
  String _error = "";
  Future<void> Function()? _function;

  static final _instance = WallpaperService._();
  WallpaperService._();
  factory WallpaperService.instance() => _instance;

  WallpaperController get wallpaperController => _wallpaperController;
  InternetService get internet => _internet;
  int get offset => _offset;
  String get error => _error;

  set generalError(String value) => _error = value;

  Future<void> getFunction({required Future<void> Function() func}) async {
    _function = func;
  }

  Future<void> initializeInternetInstance() async {
    if (_function == null) { throw Exception("É necessário receber a função service."); }

    _internet = InternetService.withoutParam(func: _function!);
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

    await _wallpaperController.onGetWallpaper(offset: _offset);

    if (_wallpaperController.getErrorWallpaper == null) {
      ImageCacheService.wallpapers = _wallpaperController.getWallpaperModel;
    } else {
      _error = _wallpaperController.getErrorWallpaper!;
    }
  }
}
