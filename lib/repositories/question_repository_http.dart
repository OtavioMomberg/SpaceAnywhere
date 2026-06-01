import 'package:space_anywhere/models/api_models/question_model.dart';

abstract class QuestionRepositoryHttp {
  Future<QuestionModel?> getQuestion({required int id});
}