import 'package:flutter/material.dart';
import 'package:space_anywhere/services/save_image_services.dart';
import 'package:space_anywhere/themes/app_theme.dart';
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

class _ExpandedImagePageState extends State<ExpandedImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 38, 46, 139),
        foregroundColor: const Color.fromARGB(255, 206, 206, 207),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
        decoration: BoxDecoration(gradient: AppTheme.mainGradient),
        child: Column(
          mainAxisAlignment: .start,
          spacing: 20,
          children: <Widget>[
            Expanded(
              child: Center(child: ImageWidget(imagePath: widget.imagePath, option: widget.option))
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
    final response = await SaveImageServices.saveImageFromUrl(imageUrl: widget.imagePath);
    showResponse(response: response);
  }

  void showResponse({required bool response}) {
    showDialog(
      context: context,
      builder: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(seconds: 3));
          if (!mounted) return;
          Navigator.pop(context);
        });

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(response ? "Sucesso!" : "Erro."),
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
            ]
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(response ? "Imagem salva na galeria!" : "Houve um erro ao tentar salvar imagem.")
              ]
            )
          )
        );
      }
    );
  }
}