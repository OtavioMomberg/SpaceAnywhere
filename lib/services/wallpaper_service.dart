import 'package:http/http.dart';
import 'package:space_anywhere/controllers/wallpaper_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/repositories/implementations/wallpaper_implementation_http.dart';
import 'package:space_anywhere/utils/image_cache_service.dart';

class WallpaperService {
  final WallpaperController _wallpaperController = WallpaperController(WallpaperImplementationHttp(Client()));
  late Internet _internet;
  int _offset = 0;
  bool _checkFunction = false;
  String _error = "";
  Future<void> Function()? _function;

  static final _instance = WallpaperService._();
  WallpaperService._();
  factory WallpaperService.instance() => _instance;

  WallpaperController get wallpaperController => _wallpaperController;
  Internet get internet =>_internet;
  int get offset => _offset;
  String get error => _error;

  set generalError(String value) => _error = value;

  Future<void> getFunction({required Future<void> Function() func}) async {
    if (_checkFunction) return;

    _function = func;
    _checkFunction = true;
  }

  Future<void> initializeInternetInstance() async {
    if (_function == null) throw Exception("É necessário receber a função service.");

    _internet = Internet.withoutParam(func: _function!);
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