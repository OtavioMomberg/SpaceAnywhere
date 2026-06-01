import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:ui';
import 'package:space_anywhere/controllers/question_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/repositories/implementations/question_inplementation_http.dart';
import 'package:space_anywhere/widgets/answer_card.dart';
import 'package:space_anywhere/widgets/button.dart';
import 'package:space_anywhere/widgets/info_error_home.dart';
import 'package:space_anywhere/widgets/question_card.dart';
import 'package:space_anywhere/widgets/stylized_container.dart';

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
  bool checkAPI = false;
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
    
    if (!checkInternet) {
      if (!mounted) return;
      setState(() => isLoading = false);
      return;
    }

    checkAPI = await Internet.isApiAwake();

    if (!checkAPI) {
      if (!mounted) return;
      setState(() => isLoading = false);
      return;
    }

    await questionController.onGetQuestion(id: questionId ?? id);

    if (!mounted) return;
    if (questionId != null) {
      showStylizedSnackBar(context:  context, msm:  "Próxima pergunta!", txtColor: Colors.white);
      await Future.delayed(Duration(milliseconds: 500));
    }

    if (!mounted) return;
    setState(() => isLoading = false);

    if (questionId == null) showStylizedSnackBar(context: context, msm: "Acesso Liberado!", txtColor: Colors.lightBlueAccent);

    if (questionController.getErrorQuestion != null) error = questionController.getErrorQuestion!;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        if (!quizStarted)...[
          Text("Quiz", style: TextStyle(color: Color.fromARGB(255, 206, 206, 207), fontWeight: FontWeight.bold, fontSize: 30)),
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
                        color: Color.fromARGB(255, 206, 206, 207),
                        fontSize: 18
                      )
                    ),
                    Icon(Icons.rocket_launch, color: Color.fromARGB(255, 206, 206, 207), size: 30)
                  ]
                )
              )
            )
          ),
          const SizedBox(height: 40),
          if (isLoading)...[
            StylizedContainer(
              height: size.height * 0.6,
              child: CircularProgressIndicator(
                color: Colors.white.withValues(alpha: 0.5),
              )
            )
          ] else...[
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Button(
                label: "Jogar", 
                awaitFunction: startQuiz
              )
            )
          ]
        ] else if (!checkInternet)...[
          InfoErrorHome(message: "Erro. Sem conexão com a internet", icon: Icons.wifi_off, height: size.height * 0.6)
        ] else if (!checkAPI)...[
          InfoErrorHome(message: "Erro. Não foi possível se conectar ao servidor", icon: Icons.dns, height: size.height * 0.6)
        ] else...[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: QuestionCard(
                question: questionController.getQuestionModel!.question,
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
                      option: questionController.getQuestionModel!.alternatives[index],
                      color: Color.fromARGB(255, 206, 206, 207), 
                      onTap: onTapAnswer
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

  Future<void> closeDialog([bool? retry]) async {
    if (retry == null) {
      await getQuestion(questionController.getQuestionModel!.id);
    }

    if (!mounted) return;
    Navigator.pop<bool?>(context, retry);
  }

  Future<bool> openRetryDialog() async {
    final bool? retry = await showDialog<bool>(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          closeDialog(await retryInternetConnection());
        });
        return const AlertDialog(
          title: Center(child: Text("Tentando Conexão...")),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 38, 46, 139)
              )
            )
          )
        );
      }
    );
    return retry ?? false;
  }

  Future<bool> retryInternetConnection() async {  
    await getQuestion();
    return checkAPI ? true : false;
  }

  Future<void> onTapAnswer({required int index}) async {
    if (questionController.getQuestionModel!.rightAnswerIndex == index) {
      await showResponseMessage(isAnswerCorrect: true);
    } else {
      await showResponseMessage(isAnswerCorrect: false);
    }
  }

  Future<void> showResponseMessage({required bool isAnswerCorrect}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          closeDialog();
        });
        return AlertDialog(
          title: Center(
            child: Text(isAnswerCorrect ? "Parabéns!" : "Quase lá!"),
          ),
          content: SizedBox(
            height: 200,
            width: 300,
            child: Column(
              spacing: 15,
              mainAxisAlignment: isAnswerCorrect ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  isAnswerCorrect 
                    ? "Certa Resposta!" 
                    : "Resposta Incorreta. Alternativa correta:",
                  style: const TextStyle(
                    fontSize: 18
                  ),
                  textAlign: TextAlign.center
                ),
                Text(
                  isAnswerCorrect 
                    ? "" 
                    : "${questionController.getQuestionModel!.alternatives[questionController.getQuestionModel!.rightAnswerIndex]} ",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify
                )
              ]
            )
          )
        );
      }
    );
  }

  void showStylizedSnackBar({required BuildContext context, required String msm, required Color txtColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(10),
        content: Center(
          child: Text(
            msm, 
            style: const TextStyle(
              color: Colors.white
            )
          )
        ),
        backgroundColor: txtColor.withValues(alpha: 0.15),
        shape: StadiumBorder(
          side: BorderSide(
            color: txtColor.withValues(alpha: 0.5)
          )
        ),
        duration: const Duration(seconds: 1)
      )
    );
  }

  void showError() {
    showStylizedSnackBar(context: context, msm: "Não foi possível se conectar ao servidor.", txtColor: Colors.red);
  }
}