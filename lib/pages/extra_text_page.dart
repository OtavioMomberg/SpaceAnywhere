import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:space_anywhere/themes/app_theme.dart';

class ExtraTextPage extends StatelessWidget {
  final String title;
  final String text;
  const ExtraTextPage({
    required this.title,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 38, 46, 139),
        foregroundColor: const Color.fromARGB(255, 206, 206, 207)
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: AppTheme.mainGradient
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: <Widget>[
            Text(
              title, 
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 207), 
                fontWeight: FontWeight.bold,
                fontSize: 16
              ), 
              maxLines: 2,
              textAlign: TextAlign.center
            ),
            Center(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    height: size.height * 0.75,
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      color: Colors.white.withValues(alpha: 0.15)
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 20,
                        children: <Widget>[
                          Text(
                            text, 
                            style: const TextStyle(
                              color: Color.fromARGB(255, 206, 206, 207),
                              height: 1.7
                            ), 
                            textAlign: TextAlign.justify
                          )
                        ]
                      )
                    )
                  )
                )
              )
            ),
          ],
        )
      )
    );
  }
}