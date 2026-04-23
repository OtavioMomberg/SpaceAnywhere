import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    
    return Center(child: const Text("QUIZ", style: TextStyle(color: Color.fromARGB(255, 206, 206, 207))));
  }
}