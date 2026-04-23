import 'package:flutter/material.dart';
import 'package:space_anywhere/themes/app_theme.dart';
import 'package:space_anywhere/widgets/stylized_container.dart';

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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 38, 46, 139),
        foregroundColor: const Color.fromARGB(255, 206, 206, 207)
      ),
      body: Container(
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
            Flexible(
              child: FractionallySizedBox(
                heightFactor: 0.9,
                child: StylizedContainer(
                  widthFactor: 0.95,
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
          ]
        )
      )
    );
  }
}