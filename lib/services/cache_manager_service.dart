import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerService {
  static final instance = CacheManager(
    Config(
      "wallpaper_cache",
      stalePeriod: Duration(days: 1),
      maxNrOfCacheObjects: 10
    )
  );
}