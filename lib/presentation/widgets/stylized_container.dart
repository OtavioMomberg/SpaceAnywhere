import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:space_anywhere/presentation/themes/app_theme.dart';

class StylizedContainer extends StatelessWidget {
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Widget? child;
  final double? height;

  const StylizedContainer({
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.child,
    this.height,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Center(
        child: ClipRRect(
          borderRadius: borderRadius == null ? AppTheme.borderRadius : borderRadius!,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              height: height,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: borderRadius == null ? AppTheme.borderRadius : borderRadius!,
                border: Border.all(
                  color: borderColor == null
                    ? AppTheme.color1.withValues(alpha: 0.5)
                    : borderColor!.withValues(alpha: 0.5),
                ),
                color: borderColor == null
                  ? AppTheme.color1.withValues(alpha: 0.15)
                  : borderColor!.withValues(alpha: 0.15),
              ),
              child: height != null ? Center(child: child) : child
            )
          )
        )
      )
    );
  }
}
