import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final int? pageIndex;
  final void Function({int? index})? function;
  final Future<void> Function()? awaitFunction;
  const Button({
    required this.label, 
    this.pageIndex,
    this.function,
    this.awaitFunction,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.15),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (awaitFunction?.call() != null) { return; }
          function!(index: pageIndex);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.3)
            )
          ),
          height: 50,
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
            )
          )
        )
      )
    );
  }
}
