import 'package:flutter/material.dart';
import 'package:space_anywhere/services/calculator_service.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';

class ExpansibleHeader extends StatelessWidget {
  final ExpansibleController controller;
  final CalculatorService _calculatorService;

  const ExpansibleHeader({
    required this.controller, 
    required CalculatorService calculatorService,
    super.key
  }) : _calculatorService = calculatorService;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.borderRadius,
        border: Border.all(
          width: 1.5,
          color: AppTheme.color1.withValues(alpha: 0.5)
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
                color: AppTheme.color1.withValues(alpha: 0.8)
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
              color: AppTheme.color1.withValues(alpha: 0.8)
            )
          )
        ]
      )
    );
  }
}


