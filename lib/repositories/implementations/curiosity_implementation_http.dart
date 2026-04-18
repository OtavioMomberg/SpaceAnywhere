import 'package:http/http.dart';
import 'package:space_anywhere/models/api_models/curiosity_model.dart';
import 'package:space_anywhere/repositories/curiosity_repository_http.dart';
import 'package:space_anywhere/repositories/route/api_route.dart';

class CuriosityImplementationHttp implements CuriosityRepositoryHttp {
  final Client _client;

  CuriosityImplementationHttp({required Client client}) : _client = client;

  @override
  Future<CuriosityModel?> getCuriosity(int id) async {
    print("AQUI");
    print(id);
    try {
      final url = "$URL/api/v1/curiosity/$id";
      print(url);
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      print("AQUI2");
      if (response.statusCode == 200) {
        print("DEU BOM");
        //print(response.body);
        return CuriosityModel.fromJson(response.body);
      } else {
        print("DEU RUIM");
        throw Exception(response.body);
      }

    } catch(error) {
      throw Exception(error.toString());
    }
  }
}