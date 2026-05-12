import 'package:space_anywhere/models/api_models/question_model.dart';
import 'package:space_anywhere/repositories/question_repository_http.dart';

class QuestionController {
  final QuestionRepositoryHttp questionRepositoryHttp;

  QuestionController(this.questionRepositoryHttp);

  String? _errorGetQuestion;

  String? get getErrorQuestion => _errorGetQuestion;

  bool _isLoading = true;

  bool get getIsLoading => _isLoading;

  QuestionModel? _questionModel;

  QuestionModel? get getQuestionModel => _questionModel;

  Future<void> onGetQuestion(int id) async {
    _errorGetQuestion = null;
    _isLoading = true;
    try {
      final response = await questionRepositoryHttp.getQuestion(id);

      if (response != null) _questionModel = response;
    } catch(error) {
      //List<String> split = error.toString().split('"');
      //_errorGetQuestion = split[split.length-2];
      _errorGetQuestion = error.toString();
    }
    _isLoading = false;
  }
}