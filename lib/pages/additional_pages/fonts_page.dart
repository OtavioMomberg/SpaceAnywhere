import 'package:flutter/material.dart';
import 'package:space_anywhere/services/open_links_service.dart';
import 'package:space_anywhere/themes/app_theme.dart';

class FontsPage extends StatelessWidget {
  final List<String> fonts;

  const FontsPage({required this.fonts, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.color2,
        foregroundColor: AppTheme.color1,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(gradient: AppTheme.mainGradient),
        child: Column(
          spacing: 20,
          children: <Widget>[
            const Text(
              "Fontes Consultadas",
              style: TextStyle(color: AppTheme.color1, fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: fonts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Material(
                      borderRadius: AppTheme.borderRadius,
                      color: AppTheme.color1.withValues(alpha: 0.1),
                      child: InkWell(
                        borderRadius: AppTheme.borderRadius,
                        onTap: () => OpenLinksService.openLink(url: fonts[index]),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            fonts[index],
                            style: TextStyle(
                              color: AppTheme.color1,
                              decoration: TextDecoration.underline,
                              decorationColor: AppTheme.color1
                            )
                          )
                        )
                      )
                    )
                  );
                }
              )
            )
          ]
        )
      )
    );
  }
}
