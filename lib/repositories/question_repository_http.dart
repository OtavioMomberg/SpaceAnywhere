import 'package:space_anywhere/models/api_models/question_model.dart';

abstract interface class QuestionRepositoryHttp {
  Future<QuestionModel?> getQuestion({required int id});
}