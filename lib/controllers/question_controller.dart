import 'package:space_anywhere/models/api_models/question_model.dart';
import 'package:space_anywhere/repositories/question_repository_http.dart';

class QuestionController {
  final QuestionRepositoryHttp _questionRepositoryHttp;

  QuestionController(this._questionRepositoryHttp);

  String? _errorGetQuestion;

  String? get getErrorQuestion => _errorGetQuestion;

  QuestionModel? _questionModel;

  QuestionModel? get getQuestionModel => _questionModel;

  Future<void> onGetQuestion({required int id}) async {
    _errorGetQuestion = null;
    try {
      final response = await _questionRepositoryHttp.getQuestion(id: id);

      if (response != null) { _questionModel = response; }
    } catch(error) {
      _errorGetQuestion = error.toString();
    }
  }
}