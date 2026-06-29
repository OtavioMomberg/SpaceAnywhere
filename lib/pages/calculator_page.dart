import 'package:flutter/material.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;

    return Center(
      child: const Text(
        "CALCULADORA",
        style: TextStyle(color: Color.fromARGB(255, 206, 206, 207))
      )
    );
  }
}
