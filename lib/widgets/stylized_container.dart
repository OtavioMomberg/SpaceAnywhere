import 'package:flutter/material.dart';
import 'dart:ui';

class StylizedContainer extends StatelessWidget {
  final double widthFactor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Widget? child;

  const StylizedContainer({
    required this.widthFactor,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Center(
          child: ClipRRect(
            borderRadius: borderRadius == null
                ? BorderRadius.circular(12)
                : borderRadius!,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: borderRadius == null
                      ? BorderRadius.circular(12)
                      : borderRadius!,
                  border: Border.all(
                    color: borderColor == null
                        ? Colors.white.withValues(alpha: 0.5)
                        : borderColor!.withValues(alpha: 0.5),
                  ),
                  color: borderColor == null
                      ? Colors.white.withValues(alpha: 0.15)
                      : borderColor!.withValues(alpha: 0.15),
                ),
                child: child
              )
            )
          )
        )
      )
    );
  }
}
