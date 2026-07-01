import 'package:flutter/material.dart';

class InputNumber extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const InputNumber({required this.controller, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      style: TextStyle(color: const Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.8)),
      decoration: InputDecoration(
        hint: Text(label, style: TextStyle(color: const Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.8))),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1.5,
            color: const Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.3)
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1.5,
            color: const Color.fromARGB(255, 206, 206, 207,).withValues(alpha: 0.3)
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1.5,
            color: const Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.3)
          )
        )
      )
    );
  }
}
