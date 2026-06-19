import 'package:http/http.dart';
import 'package:space_anywhere/controllers/question_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/repositories/implementations/question_inplementation_http.dart';

class QuizService {
  // attributes
  static final QuestionController _questionController = QuestionController(
    QuestionInplementationHttp(client: Client())
  );
  final int _id = 0;
  bool _quizStarted = false;
  bool _checkInternet = false;
  bool _checkAPI = false;
  String _error = "";

  // getters
  QuestionController get questionController => _questionController;
  bool get quizStarted => _quizStarted;
  bool get checkInternet => _checkInternet;
  bool get checkAPI => _checkAPI;
  String get error => _error;

  // method to change the quiz screen state
  void changeQuizState() => _quizStarted = !_quizStarted;

  // callbacks to auxiliate some methods 
  final void Function({required bool isCorrect, String? correctAnswer}) showResponse;
  final Future<void> Function() closeDialog;

  // instance
  QuizService({
    required this.showResponse,
    required this.closeDialog
  });

  // get question method
  // check the internet [_checkInternet] and the API [_checkAPI]
  // the controller call the [onGetQuestion] method
  // if error, assign it to [_error]
  Future<void> getQuestion({int? questionId}) async {
    if (questionId != null) { await Future.delayed(Duration(seconds: 1)); }
    
    _checkInternet = await Internet.hasInternet();

    if (!_checkInternet) {
      _quizStarted = true;
      return;
    }
    _checkAPI = await Internet.isApiAwake();

    if (!_checkAPI) {
      _quizStarted = true;
      return;
    }

    await _questionController.onGetQuestion(id: questionId ?? _id);

    if (_questionController.getErrorQuestion != null) { _error = _questionController.getErrorQuestion!; }
  }

  // answer method
  // compare the given index with the correct answer index 
  // if true - show the correct answer page
  // if false - show the error answer page and the correct answer is revealed
  // close the answer page
  Future<void> onTapAnswer({required int index}) async {
    if (questionController.getQuestionModel!.rightAnswerIndex == index) {
      showResponse(isCorrect: true);
    } else {
      showResponse(
        isCorrect: false, 
        correctAnswer: 
        questionController.getQuestionModel!.alternatives[questionController.getQuestionModel!.rightAnswerIndex]
      );
    }
    await closeDialog();
  }
}