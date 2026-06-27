import 'package:http/http.dart';
import 'package:space_anywhere/controllers/question_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/repositories/implementations/question_inplementation_http.dart';

class QuizService {
  static final QuestionController _questionController = QuestionController(QuestionInplementationHttp(client: Client()));
  late Internet _internet;
  final int _id = 0;
  bool _quizStarted = false;
  String _error = "";
  Future<void> Function({int? questionId})? _callQuizService; 
  void Function({required bool isCorrect, String? correctAnswer})? _showResponse;
  Future<void> Function()? _closeAnswerPage;

  static final _instance = QuizService._();
  QuizService._();
  factory QuizService.instance() => _instance;

  QuestionController get questionController => _questionController;
  Internet get internet => _internet;
  bool get quizStarted => _quizStarted;
  String get error => _error;

  set generalError(String value) => _error = value;
  
  void initializeQuiz() => _quizStarted = false;

  Future<void> getFunctions({
    required Future<void> Function({int? questionId}) callQuizService, 
    required void Function({required bool isCorrect, String? correctAnswer}) showResponse, 
    required Future<void> Function() closeAnswerPage
  }) async {
    _callQuizService = callQuizService;
    _showResponse = showResponse;
    _closeAnswerPage = closeAnswerPage;
  }

  Future<void> initializeInternetInstance() async {
    if (_callQuizService == null) throw Exception("É necessário receber a função service.");
    _internet = Internet.withParam(func: _callQuizService!);
  }

  void changeQuizState() => _quizStarted = !_quizStarted;

  Future<void> getQuestion({int? questionId}) async {
    await _internet.hasInternet();

    if (questionId != null && !_internet.checkInternet) { await Future.delayed(Duration(seconds: 3)); }
    if (!_internet.checkInternet) {
      _quizStarted = true;
      return;
    }

    await _internet.isApiAwake();

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
    if (_showResponse == null || _closeAnswerPage == null) { throw Exception("É necessário receber a função service."); }

    var controller = questionController.getQuestionModel!;
    if (controller.rightAnswerIndex == index) {
      _showResponse!(isCorrect: true);
    } else {
      _showResponse!(
        isCorrect: false,
        correctAnswer: controller.alternatives[controller.rightAnswerIndex]
      );
    }
    await _closeAnswerPage!();
  }
}
