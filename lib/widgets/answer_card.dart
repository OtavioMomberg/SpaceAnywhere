import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:space_anywhere/audio_services/audio_services.dart';

class AnswerCard extends StatelessWidget {
  final int index;
  final String option;
  final Color color;
  final Future<void> Function(int) onTap;

  const AnswerCard({
    required this.index,
    required this.option,
    required this.color,
    required this.onTap,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white.withValues(alpha: 0.01),
      child: InkWell(
        onTap: () {
          AudioServices.play("audios/button_click2.mp3", 1);
          onTap(index);
        },
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                color: Colors.white.withValues(alpha: 0.15)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(
                  option, 
                  textAlign: TextAlign.start, 
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.white
                  )
                )
              )
            )
          )
        )
      )
    );
  }
}