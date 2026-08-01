import 'package:flutter/material.dart';
import 'package:space_anywhere/themes/app_theme.dart';

class InputNumber extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const InputNumber({required this.controller, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      cursorColor: AppTheme.color1,
      style: TextStyle(color: AppTheme.color1.withValues(alpha: 0.8)),
      decoration: InputDecoration(
        hint: Text(label, style: TextStyle(color: AppTheme.color1.withValues(alpha: 0.8))),
        border: OutlineInputBorder(
          borderRadius: AppTheme.borderRadius,
          borderSide: BorderSide(
            width: 1.5,
            color: AppTheme.color1.withValues(alpha: 0.5)
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.borderRadius,
          borderSide: BorderSide(
            width: 1.5,
            color: AppTheme.color1.withValues(alpha: 0.5)
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTheme.borderRadius,
          borderSide: BorderSide(
            width: 1.5,
            color: AppTheme.color1.withValues(alpha: 0.5)
          )
        )
      )
    );
  }
}
