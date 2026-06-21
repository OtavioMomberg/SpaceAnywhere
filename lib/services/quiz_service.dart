import 'package:http/http.dart';
import 'package:space_anywhere/controllers/question_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/repositories/implementations/question_inplementation_http.dart';

class QuizService {
  static final QuestionController _questionController = QuestionController(QuestionInplementationHttp(client: Client()));
  final Internet _internet = Internet();
  final int _id = 0;
  bool _quizStarted = false;
  String _error = "";

  QuestionController get questionController => _questionController;
  Internet get internet => _internet;
  bool get quizStarted => _quizStarted;
  String get error => _error;

  void changeQuizState() => _quizStarted = !_quizStarted;

  final void Function({required bool isCorrect, String? correctAnswer}) showResponse;
  final Future<void> Function() closeAnswerPage;

  QuizService({required this.showResponse, required this.closeAnswerPage});

  Future<void> getQuestion({int? questionId}) async {
    await _internet.verifyInternet();

    if (questionId != null && !_internet.checkInternet) { await Future.delayed(Duration(seconds: 3)); }

    if (!_internet.checkInternet) {
      _quizStarted = true;
      return;
    }
    await _internet.verifyAPI();

    if (!_internet.checkAPI) {
      _quizStarted = true;
      return;
    }

    await _questionController.onGetQuestion(id: questionId ?? _id);

    if (_questionController.getErrorQuestion != null) {
      _error = _questionController.getErrorQuestion!;
    }
  }

  Future<void> onTapAnswer({required int index}) async {
    var controller = questionController.getQuestionModel!;

    if (questionController.getQuestionModel!.rightAnswerIndex == index) {
      showResponse(isCorrect: true);
    } else {
      showResponse(
        isCorrect: false,
        correctAnswer: controller.alternatives[controller.rightAnswerIndex]
      );
    }
    await closeAnswerPage();
  }
}
