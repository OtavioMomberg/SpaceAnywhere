import 'package:flutter/material.dart';
import 'package:space_anywhere/themes/app_theme.dart';

class Button extends StatelessWidget {
  final String label;
  final int? pageIndex;
  final VoidCallback? funcWithoutParam;
  final void Function({int? index})? function;
  final Future<void> Function()? awaitFunction;
  const Button({
    required this.label, 
    this.pageIndex,
    this.funcWithoutParam,
    this.function,
    this.awaitFunction,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: AppTheme.borderRadius,
      color: AppTheme.color1.withValues(alpha: 0.15),
      child: InkWell(
        borderRadius: AppTheme.borderRadius,
        onTap: () async {
          if (awaitFunction != null) {
            await awaitFunction!();
            return;
          }
          if (funcWithoutParam != null) {
            funcWithoutParam!();
            return;
          }
          if (function != null) { function!(index: pageIndex); }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppTheme.borderRadius,
            border: Border.all(
              color: AppTheme.color1.withValues(alpha: 0.5)
            )
          ),
          height: 50,
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: AppTheme.color1.withValues(alpha: 0.8)),
            )
          )
        )
      )
    );
  }
}
