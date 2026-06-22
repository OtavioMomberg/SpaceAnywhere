import 'package:flutter/material.dart';
import 'package:space_anywhere/pages/result_page.dart';
import 'dart:ui';
import 'package:space_anywhere/services/quiz_service.dart';
import 'package:space_anywhere/widgets/answer_card.dart';
import 'package:space_anywhere/widgets/button.dart';
import 'package:space_anywhere/widgets/check_connection.dart';
import 'package:space_anywhere/widgets/question_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizService _quizService = QuizService.instance();
  bool isLoading = true;
  bool retrySucced = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _quizService.getFunctions(
          callQuizService: callQuizService, 
          showResponse: showResponse, 
          closeAnswerPage: closeAnswerPage
        );
        _quizService.initializeInternetInstance();
        _quizService.internet.retryConnectionSystemWithParam();
      } on Exception catch (error) {
        _quizService.generalError = error.toString();
        _quizService.internet.updateInternetStatus(status: true);
        _quizService.internet.updateAPIStatus(status: true);
        isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: .start,
      children: <Widget>[
        if (!_quizService.quizStarted) ...[
          Text(
            "Quiz",
            style: TextStyle(
              color: Color.fromARGB(255, 206, 206, 207),
              fontWeight: FontWeight.bold,
              fontSize: 30
            )
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5)
                  ),
                  color: Colors.white.withValues(alpha: 0.1)
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  spacing: 20,
                  children: <Widget>[
                    const Text(
                      "Quiz de Astronômia",
                      style: TextStyle(
                        color: Color.fromARGB(255, 206, 206, 207),
                        fontSize: 18
                      )
                    ),
                    Icon(
                      Icons.rocket_launch,
                      color: Color.fromARGB(255, 206, 206, 207),
                      size: 30
                    )
                  ]
                )
              )
            )
          ),
          const SizedBox(height: 40),
          if (isLoading) ...[
            CircularProgressIndicator.adaptive(
              backgroundColor: Color.fromARGB(255, 206, 206, 207)
            )
          ] else ...[
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Button(label: "Jogar", awaitFunction: startQuiz)
            )
          ]
        ] else if (!_quizService.internet.checkInternet || !_quizService.internet.checkAPI) ...[
          CheckConnection(
            checkInternet: _quizService.internet.checkInternet,
            checkAPI: _quizService.internet.checkAPI,
            height: size.height * 0.6
          )
        ] else if (_quizService.questionController.getErrorQuestion == null) ...[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: QuestionCard(
                question: _quizService.questionController.getQuestionModel!.question,
                color: Color.fromARGB(255, 206, 206, 207)
              )
            )
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: <Widget>[
                  ...List.generate(5, (index) {
                    return AnswerCard(
                      index: index,
                      option: _quizService.questionController.getQuestionModel!.alternatives[index],
                      color: Color.fromARGB(255, 206, 206, 207),
                      onTap: ({required int index}) async => await _quizService.onTapAnswer(index: index)
                    );
                  })
                ]
              )
            )
          )
        ] else ...[
          Text(
            _quizService.error,
            style: const TextStyle(color: Color.fromARGB(255, 206, 206, 207)),
            textAlign: TextAlign.center
          )
        ]
      ]
    );
  }

  Future<void> callQuizService({int? questionId}) async {
    await _quizService.getQuestion(questionId: questionId);

    if (!mounted) { return; }
    if (questionId != null) {
      if (!_quizService.internet.checkInternet || !_quizService.internet.checkAPI) {
        if (_quizService.internet.currentRetryAttempt == _quizService.internet.retryAttempts) { 
          _quizService.internet.sendQuestionId = questionId;
          _quizService.internet.retryConnectionSystemWithParam(); 
          setState(() => retrySucced = true);
        }
        return; 
      }
      await showStylizedSnackBar(
        context: context,
        msm: retrySucced ? "Conexão Reestabelecida!" : "Próxima pergunta!",
        txtColor: retrySucced ? Colors.lightBlueAccent : Colors.white
      );
    }

    await Future.delayed(Duration(seconds: 1));

    if (!mounted) { return; }
    setState(() {
      isLoading = false;
      retrySucced = false;
    });
  }

  Future<void> startQuiz() async {
    if (_quizService.error.isNotEmpty) {
      await showError();
      return;
    }
    if (!mounted) { return; }
    setState(() => _quizService.changeQuizState());
  }

  Future<void> closeAnswerPage() async {
    await callQuizService(questionId: _quizService.questionController.getQuestionModel!.id);

    if (!mounted) { return; }
    Navigator.pop(context);
  }

  void showResponse({required bool isCorrect, String? correctAnswer}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, _, _) => ResultPage(isCorrect: isCorrect, correctAnswer: correctAnswer),
        transitionsBuilder: (_, animation, _, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child
          );
        }
      )
    );
  }

  Future<void> showStylizedSnackBar ({required BuildContext context,required String msm,required Color txtColor}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(10),
        content: Center(
          child: Text(msm, style: const TextStyle(color: Colors.white)),
        ),
        backgroundColor: txtColor.withValues(alpha: 0.15),
        shape: StadiumBorder(
          side: BorderSide(color: txtColor.withValues(alpha: 0.5)),
        ),
        duration: const Duration(seconds: 1)
      )
    );
  }

  Future<void> showError() async {
    await showStylizedSnackBar(
      context: context,
      msm: "Não foi possível se conectar ao servidor.",
      txtColor: Colors.red
    );
  }
}