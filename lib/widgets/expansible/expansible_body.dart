import 'package:flutter/material.dart';
import 'package:space_anywhere/services/calculator_service.dart';

class ExpansibleBody extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;
  final _calculatorService = CalculatorService.instance();

  ExpansibleBody({
    required this.controller,
    required this.setStateCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  _calculatorService.planetsGravity[index].name,
                  style: TextStyle(color: Color.fromARGB(255, 206, 206, 207))
                )
              )
            )
          );
        },
      ),
    );
  }
}
