import 'package:http/http.dart';
import 'package:space_anywhere/models/api_models/wallpaper_model.dart';
import 'package:space_anywhere/routes/api_route.dart';
import 'package:space_anywhere/repositories/wallpaper_repository_http.dart';

class WallpaperImplementationHttp implements WallpaperRepositoryHttp {
  final Client _client;

  WallpaperImplementationHttp(Client client) : _client = client;

  @override
  Future<List<WallpaperModel?>> getWallpaper({int? offset}) async {
    try {
      final path = "/api/v1/wallpapers/";
      final queryParam = {"offset": offset.toString()};
      final response = await _client.get(
        Uri.https(URL, path, queryParam),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return WallpaperModel.listFromJson(source: response.body);
      } else {
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception(error.toString());
    }
  }
}