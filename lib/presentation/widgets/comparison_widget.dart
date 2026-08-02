import 'package:flutter/material.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';
import 'package:space_anywhere/core/utils/image_option_service.dart';
import 'package:space_anywhere/presentation/widgets/image_widget.dart';
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
                  child: Center(
                    child: ImageWidget(
                      imagePath: objectData.imagePath, 
                      option: ImageOption.asset
                    )
                  )
                ),
                Text(
                  "*Imagem gerada por Inteligência Artificial",
                  style: TextStyle(color: AppTheme.color1),
                )
              ]
            ),

            const SizedBox(height: 10),
            Divider(),
            Center(child: Text(objectData.name, style: TextStyle(color: AppTheme.color1))),
            Divider(),
            const SizedBox(height: 10),

            Text(
              "Diâmetro: ${objectData.diameter}", 
              style: const TextStyle(color: AppTheme.color1)
            ),
            Text(
              "Massa: ${objectData.mass}", 
              style: const TextStyle(color: AppTheme.color1)
            ),
            Text(
              "Distância para Terra: ${objectData.earthDistance}", 
              style: const TextStyle(color: AppTheme.color1)
            ),
            Text(
              "Tipo de objeto: ${objectData.objectType}", 
              style: const TextStyle(color: AppTheme.color1)
            )
          ]
        )
      )
    );
  }
}
