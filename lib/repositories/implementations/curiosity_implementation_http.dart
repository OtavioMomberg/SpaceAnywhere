import 'package:http/http.dart';
import 'package:space_anywhere/models/api_models/curiosity_model.dart';
import 'package:space_anywhere/repositories/curiosity_repository_http.dart';
import 'package:space_anywhere/repositories/route/api_route.dart';

class CuriosityImplementationHttp implements CuriosityRepositoryHttp {
  final Client _client;

  CuriosityImplementationHttp({required Client client}) : _client = client;

  @override
  Future<CuriosityModel?> getCuriosity(int id) async {
    try {
      final url = "$URL/api/v1/curiosity/$id";
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return CuriosityModel.fromJson(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch(error) {
      throw Exception(error.toString());
    }
  }
}