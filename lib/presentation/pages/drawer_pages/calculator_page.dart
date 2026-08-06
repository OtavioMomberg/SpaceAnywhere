import 'package:flutter/material.dart';
import 'package:space_anywhere/services/calculator_service.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';
import 'package:space_anywhere/presentation/widgets/button.dart';
import 'package:space_anywhere/presentation/widgets/calculus_result.dart';
import 'package:space_anywhere/presentation/widgets/expansible/expansible_widget.dart';
import 'package:space_anywhere/presentation/widgets/input_number.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _calculatorService = CalculatorService.instance();
  final _textController = TextEditingController();
  final _expansibleController = ExpansibleController();

  @override
  void initState() {
    super.initState();
    _calculatorService.setDefaultText();
    _calculatorService.initializeResult();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: <Widget>[
          const Text(
            "Calcule seu peso em outros planetas",
            style: TextStyle(
              color: AppTheme.color1,
              fontWeight: FontWeight.bold,
              fontSize: 16
            )
          ),
          const SizedBox(height: 30),
          InputNumber(controller: _textController, label: "Insira seu peso"),
          ExpansibleWidget(
            controller: _expansibleController, 
            setStateCallback: () => setState((){})
          ),
          if (_calculatorService.defaultText != "Escolha um objeto")...[
            const SizedBox(height: 20),
            Button(
              label: "Calcular", 
              function: () {
                _calculatorService.calculate(weight: _textController.text);
                setState((){});
              }
            ),
            if (_calculatorService.result != 0.0)...[
              const SizedBox(height: 20),
              CalculusResult(),
              const SizedBox(height: 10),
              Button(
                label: "Limpar",
                function: cleanPage
              )
            ]
          ]
        ]
      )
    );
  }

  void cleanPage() {
    _calculatorService.setDefaultText();
    _calculatorService.initializeResult();
    _textController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _expansibleController.dispose();
    super.dispose();
  }
}