import 'package:flutter/material.dart';

mixin StylizedSnackBar {
  Future<void> showStylizedSnackBar({required BuildContext context, required String msm, required Color txtColor}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(10),
        content: Center(
          child: Text(msm, style: const TextStyle(color: Colors.white)),
        ),
        backgroundColor: txtColor.withValues(alpha: 0.15),
        shape: StadiumBorder(
          side: BorderSide(color: txtColor.withValues(alpha: 0.5)),
        ),
        duration: const Duration(seconds: 1)
      )
    );
  }
}