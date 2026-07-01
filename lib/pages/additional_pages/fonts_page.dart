import 'package:flutter/material.dart';
import 'package:space_anywhere/internet/open_links.dart';
import 'package:space_anywhere/themes/app_theme.dart';

class FontsPage extends StatelessWidget {
  final List<String> fonts;

  const FontsPage({
    required this.fonts,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 38, 46, 139),
        foregroundColor: const Color.fromARGB(255, 206, 206, 207)
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          gradient: AppTheme.mainGradient
        ),
        child: Column(
          spacing: 20,
          children: <Widget>[
            const Text(
              "Fontes Consultadas",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              )
            ),
            Expanded(
              child: ListView.builder(
                itemCount: fonts.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withValues(alpha: 0.1),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => OpenLinks.openLink(url: fonts[index]),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            fonts[index],
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white
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