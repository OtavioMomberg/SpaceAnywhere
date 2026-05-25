import 'package:flutter/material.dart';
import 'package:space_anywhere/widgets/image_widget.dart';
import 'package:space_anywhere/models/comparison_models/info_object.dart';

class ComparisonWidget extends StatelessWidget {
  final InfoObject objectData;

  const ComparisonWidget({
    required this.objectData,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.3,
              width: double.infinity,
              child: Center(
                child: ImageWidget(imagePath: objectData.imagePath)
              )
            ),
            Text(
              "*Imagem gerada por Inteligência Artificial",
              style: TextStyle(color: Colors.white)
            ),
        
            const SizedBox(height: 10),
            Divider(),
            Center(child: Text(objectData.name, style: TextStyle(color: Colors.white))),
            Divider(),
            const SizedBox(height: 10),
        
            Text("Diâmetro: ${objectData.diameter}", style: const TextStyle(color: Colors.white)),
            Text("Massa: ${objectData.mass}", style: const TextStyle(color: Colors.white)),
            Text("Distância para Terra: ${objectData.earthDistance}", style: const TextStyle(color: Colors.white)),
            Text("Tipo de objeto: ${objectData.objectType}", style: const TextStyle(color: Colors.white)),
          ]
        )
      )
    );
  }
}
