import 'package:flutter/material.dart';
import 'package:space_anywhere/services/calculator_service.dart';

class ExpansibleBody extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;
  final _calculatorService = CalculatorService.instance();

  ExpansibleBody({
    required this.controller,
    required this.setStateCallback,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.5,
          color: Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.5)
        )
      ),
      child: ListView.builder(
        itemCount: _calculatorService.planetsGravity.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _calculatorService.defineNewText(index: index);
              setStateCallback();
              controller.collapse();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  _calculatorService.planetsGravity[index].name,
                  style: const TextStyle(color: Color.fromARGB(255, 206, 206, 207))
                )
              )
            )
          );
        }
      )
    );
  }
}
