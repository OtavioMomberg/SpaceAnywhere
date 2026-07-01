import 'package:flutter/material.dart';
import 'package:space_anywhere/widgets/image_widget.dart';
import 'package:space_anywhere/models/local_data_models/info_object.dart';

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
          crossAxisAlignment: .start,
          spacing: 10,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.3,
                  width: double.infinity,
                  child: Center(child: ImageWidget(imagePath: objectData.imagePath, option: "asset"))
                ),
                Text(
                  "*Imagem gerada por Inteligência Artificial",
                  style: TextStyle(color: Color.fromARGB(255, 206, 206, 207)),
                )
              ]
            ),

            const SizedBox(height: 10),
            Divider(),
            Center(child: Text(objectData.name, style: TextStyle(color: Color.fromARGB(255, 206, 206, 207)))),
            Divider(),
            const SizedBox(height: 10),

            ...List.generate(objectData.usedParamLength, (int index) {
              return Text(
                "${objectData.paramNames[index]}: ${objectData.diameter}", 
                style: const TextStyle(color: Color.fromARGB(255, 206, 206, 207))
              );
            })
          ]
        )
      )
    );
  }
}
