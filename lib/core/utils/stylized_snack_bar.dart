import 'package:flutter/material.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';

mixin StylizedSnackBar {
  Future<void> showStylizedSnackBar({required BuildContext context, required String msm, required Color txtColor}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(10),
        content: Center(
          child: Text(msm, style: const TextStyle(color: AppTheme.color6)),
        ),
        backgroundColor: txtColor.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
          side: BorderSide(color: txtColor.withValues(alpha: 0.5)),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
        ),
        duration: const Duration(seconds: 1)
      )
    );
  }
}