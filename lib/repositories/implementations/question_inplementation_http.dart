import 'package:http/http.dart';
import 'package:space_anywhere/models/api_models/question_model.dart';
import 'package:space_anywhere/repositories/question_repository_http.dart';
import 'package:space_anywhere/core/constants/api_constants.dart';

class QuestionInplementationHttp implements QuestionRepositoryHttp {
  final Client _client;

  QuestionInplementationHttp({required Client client}) : _client = client;

  @override
  Future<QuestionModel?> getQuestion({required int id}) async {
    final url = "$URL/api/v1/quiz/$id";
    final response = await _client.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return QuestionModel.fromJson(source: response.body);
    } 
    throw Exception(response.body);
  }

} 