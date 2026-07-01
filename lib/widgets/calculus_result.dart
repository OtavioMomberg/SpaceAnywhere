import 'package:flutter/material.dart';
import 'package:space_anywhere/services/calculator_service.dart';

class CalculusResult extends StatelessWidget {
  final _calculatorService = CalculatorService.instance();
  CalculusResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: <Widget>[
        Text(
          "Resultado:",
          style: TextStyle(
            color: Color.fromARGB(255, 206, 206, 207),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.3),
            ),
            color: Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.15),
          ),
          child: Center(
            child: Text(
              _calculatorService.result == null
                  ? "Erro ao realizar cálculo."
                  : "O seu peso em ${_calculatorService.defaultText}\né: ${_calculatorService.result!.toStringAsFixed(2)} kg",
              style: TextStyle(
                color: Color.fromARGB(255, 206, 206, 207),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center
            )
          )
        )
      ]
    );
  }
}
