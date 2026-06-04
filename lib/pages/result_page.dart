import 'package:flutter/material.dart';
import 'package:space_anywhere/themes/app_theme.dart';
import 'package:space_anywhere/widgets/stylized_container.dart';

class ResultPage extends StatelessWidget {
  final bool isCorrect;
  final String? correctAnswer;
  const ResultPage({
    required this.isCorrect,
    this.correctAnswer,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 38, 46, 139),
        foregroundColor: const Color.fromARGB(255, 38, 46, 139)
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(gradient: AppTheme.mainGradient),
        child: StylizedContainer(
          height: size.height * 0.6,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color:const Color.fromARGB(255, 206, 206, 207),
                  size: 60
                ),
                Text(
                  isCorrect ? "Certa Resposta!" : "Resposta Incorreta!",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 206, 206, 207),
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    )
                  ),
                if (!isCorrect)...[
                  const SizedBox(height: 10),
                  Text(
                    "Alternativa correta:",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 206, 206, 207),
                      fontSize: 14
                    )
                  ),
                  Text(
                    correctAnswer!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 206, 206, 207),
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center
                  )
                ]
              ]
            )
          )
        )
      )
    );
  }
}