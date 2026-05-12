import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:space_anywhere/controllers/question_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/repositories/implementations/question_inplementation_http.dart';
import 'dart:ui';
import 'package:space_anywhere/widgets/answer_card.dart';
import 'package:space_anywhere/widgets/button.dart';
import 'package:space_anywhere/widgets/question_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late final QuestionController questionController;
  int id = 0;
  bool quizStarted = false;
  bool checkInternet = false;
  bool isLoading = true;
  String error = "";

  @override
  void initState() {
    super.initState();

    questionController = QuestionController(
      QuestionInplementationHttp(client: Client())
    );

    getQuestion();
  }

  Future<void> verifyInternet() async {
    checkInternet = await Internet.hasInternet();
  }

  Future<void> getQuestion([int? questionId]) async {
    if (questionId != null) await Future.delayed(Duration(seconds: 1));

    await verifyInternet();
    
    if (!checkInternet) return;

    await questionController.onGetQuestion(questionId ?? id);

    setState(() => isLoading = false);
    if (questionController.getErrorQuestion != null) error = questionController.getErrorQuestion!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (!quizStarted)...[
          Text("Quiz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                  color: Colors.white.withValues(alpha: 0.1)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: <Widget>[
                    const Text(
                      "Quiz de Astronômia",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    ),
                    Icon(Icons.rocket_launch, color: Colors.white, size: 30)
                  ]
                )
              )
            )
          ),
          const SizedBox(height: 40),
          IgnorePointer(
            ignoring: !isLoading ? false : true,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Button(
                label: "Iniciar", 
                function: startQuiz
              )
            ),
          ),
        ] else...[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: QuestionCard(
                question: questionController.getQuestionModel!.question,
                color: Colors.white
              ),
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
                      option: questionController.getQuestionModel!.alternatives[index],
                      color: Colors.white, 
                      onTap: onTap
                    );
                  })
                ]
              )
            )
          )
        ]
      ]
    );
  }

  Future<void> startQuiz() async {
    bool retryCheck = false;
    if (!checkInternet) {
      retryCheck = await openRetryDialog();
    }

    if (!retryCheck && !checkInternet) {
      showError();
      return;
    }

    if (error.isNotEmpty) {
      showError();
      return;
    }

    setState(() => quizStarted = !quizStarted);
  }

  Future<bool> openRetryDialog() async {
    final bool? retry = await showDialog<bool>(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          closeDialog(await retryInternetConnection());
        });
        return AlertDialog(
          title: const Center(child: Text("Tentando Conexão...")),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Center(child: CircularProgressIndicator())
          )
        );
      }
    );
    return retry ?? false;
  }

  Future<bool> retryInternetConnection() async {
    int retry = 0;
    while(retry < 5 && !checkInternet) {
      await getQuestion();
      retry+=1;
      await Future.delayed(Duration(seconds: 1));
    }

    return checkInternet ? true : false;
  }

  void closeDialog(bool retry) {
    if (!mounted) return;
    Navigator.pop<bool>(context, retry);
  }

  void showError() {}

  void onTap(int index) {
    // VERIFY THE CORRECT ANSWER 
    if (questionController.getQuestionModel!.rightAnswerIndex == index) {
      print("CERTA RESPOSTA");
    } else {
      print("RESPOSTA ERRADA");
    }
    // GET THE NEXT QUESTION
    getQuestion(questionController.getQuestionModel!.id);
  }
}