import 'package:http/http.dart';
import 'package:space_anywhere/models/api_models/question_model.dart';
import 'package:space_anywhere/repositories/question_repository_http.dart';
import 'package:space_anywhere/repositories/route/api_route.dart';

class QuestionInplementationHttp implements QuestionRepositoryHttp {
  final Client _client;

  QuestionInplementationHttp(Client client) : _client = client;

  @override
  Future<QuestionModel?> getQuestion(int id) async {
    try {
      final url = "$URL/api/v1/question/$id";
      final response = await _client.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("DEU BOM");
        return QuestionModel.fromJson(response.body);
      } else {
        print("DEU RUIM");
        throw Exception(response.body);
      }

    } catch(error) {
      throw Exception(error.toString());
    }
  }

} 