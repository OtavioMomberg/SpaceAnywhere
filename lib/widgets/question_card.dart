import 'package:flutter/material.dart';
import 'dart:ui';

class QuestionCard extends StatelessWidget {
  final String question;
  final Color color;

  const QuestionCard({
    required this.question,
    required this.color,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            color: Colors.white.withValues(alpha: 0.15)
          ),
          child: Center(
            child: Text(
              question, 
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
            )
          )
        )
      )
    );
  }
}