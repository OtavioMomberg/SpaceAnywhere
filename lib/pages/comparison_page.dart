import 'package:flutter/material.dart';
import 'package:space_anywhere/themes/app_theme.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(gradient: AppTheme.mainGradient),
          child: Center(child: const Text("METRÍCAS", style: TextStyle(color: Color.fromARGB(255, 206, 206, 207)))),
        )
      )
    );
  }
}