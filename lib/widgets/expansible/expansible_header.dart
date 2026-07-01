import 'package:flutter/material.dart';
import 'package:space_anywhere/services/calculator_service.dart';

class ExpansibleHeader extends StatelessWidget {
  final ExpansibleController controller;
  final _calculatorService = CalculatorService.instance();

  ExpansibleHeader({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.5,
          color: Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.3)
        )
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              _calculatorService.defaultText,
              style: TextStyle(
                color: const Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.8)
              )
            )
          ),
          IconButton(
            onPressed: () {
              controller.isExpanded
                ? controller.collapse()
                : controller.expand();
            },
            icon: Icon(
              controller.isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
              color: Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.8)
            )
          )
        ]
      )
    );
  }
}


