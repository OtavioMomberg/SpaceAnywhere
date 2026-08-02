import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:space_anywhere/presentation/themes/app_theme.dart';

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
      borderRadius: AppTheme.borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: AppTheme.borderRadius,
            border: Border.all(color: AppTheme.color1.withValues(alpha: 0.5)),
            color: AppTheme.color1.withValues(alpha: 0.15)
          ),
          child: Center(
            child: Text(
              question, 
              style: TextStyle(color: AppTheme.color1),
              textAlign: TextAlign.justify
            )
          )
        )
      )
    );
  }
}