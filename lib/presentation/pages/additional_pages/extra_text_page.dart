import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';
import 'package:space_anywhere/presentation/widgets/stylized_container.dart';

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
        backgroundColor: AppTheme.color2,
        foregroundColor: AppTheme.color1,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarIconBrightness: Brightness.light
        ),

        // Gambiarra enquanto não descubro a real causa do espaço entre AppBar e Container
        shape: const BeveledRectangleBorder(
          side: BorderSide(color: AppTheme.color2, width: 2)
        ),
      ),
      backgroundColor: AppTheme.color4,
      body: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(gradient: AppTheme.mainGradient),
          child: Column(
            mainAxisAlignment: .start,
            spacing: 20,
            children: <Widget>[
              Text(
                title, 
                style: const TextStyle(
                  color: AppTheme.color1, 
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: .start,
                        spacing: 20,
                        children: <Widget>[
                          Text(
                            text, 
                            style: const TextStyle(
                              color: AppTheme.color1,
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
        ),
      )
    );
  }
}