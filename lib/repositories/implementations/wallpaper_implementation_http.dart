import 'package:http/http.dart';
import 'package:space_anywhere/models/api_models/wallpaper_model.dart';
import 'package:space_anywhere/repositories/route/api_route.dart';
import 'package:space_anywhere/repositories/wallpaper_repository_http.dart';

class WallpaperImplementationHttp implements WallpaperRepositoryHttp {
  final Client _client;

  WallpaperImplementationHttp(Client client) : _client = client;

  @override
  Future<List<WallpaperModel?>> getWallpaper(int offset) async {
    try {
      final url = "$URL/api/v1/wallpapers/$offset";
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("DEU BOM");
        print(response.body);
        return WallpaperModel.listFromJson(response.body);
      } else {
        print("DEU RUIM");
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception(error.toString());
    }
  }
}