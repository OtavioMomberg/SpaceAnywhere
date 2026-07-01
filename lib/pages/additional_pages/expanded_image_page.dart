import 'package:flutter/material.dart';
import 'package:space_anywhere/utils/save_image_services.dart';
import 'package:space_anywhere/themes/app_theme.dart';
import 'package:space_anywhere/utils/stylized_snack_bar.dart';
import 'package:space_anywhere/widgets/button.dart';
import 'package:space_anywhere/widgets/image_widget.dart';

class ExpandedImagePage extends StatefulWidget {
  final String imagePath;
  final String option;

  const ExpandedImagePage({
    required this.imagePath, 
    required this.option,
    super.key
  });

  @override
  State<ExpandedImagePage> createState() => _ExpandedImagePageState();
}

class _ExpandedImagePageState extends State<ExpandedImagePage> with StylizedSnackBar {
  bool response = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 38, 46, 139),
        foregroundColor: const Color.fromARGB(255, 206, 206, 207)
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
        decoration: BoxDecoration(gradient: AppTheme.mainGradient),
        child: Column(
          mainAxisAlignment: .start,
          spacing: 20,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ImageWidget(imagePath: widget.imagePath, option: widget.option),
              )
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Button(
                label: "Baixar",
                awaitFunction: saveImage
              )
            )
          ]
        )
      )
    );
  }

  Future<void> saveImage() async {
    await showResponse();

    if (!mounted) { return; }

    showStylizedSnackBar(
      context: context, 
      msm: response 
        ? "Imagem salva na galeria!"
        : "Erro ao salvar imagem.", 
      txtColor: response 
        ? Colors.lightBlueAccent
        : Colors.red
    );
  }

  Future<void> showResponse() async {
    await showDialog(
      context: context,
      builder: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          response = await SaveImageServices.saveImageFromUrl(imageUrl: widget.imagePath);
          if (!mounted) { return; }
          Navigator.pop(context);
        });

        return AlertDialog(
          title: Center(child: Text("Salvando imagem na galeria!")),
          content: SizedBox(
            height: 100,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              children: <Widget>[
                CircularProgressIndicator.adaptive(
                  backgroundColor: Color.fromARGB(255, 38, 46, 139)
                )      
              ]
            )
          )
        );
      }
    );
  }
}