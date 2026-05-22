import 'package:flutter/material.dart';
//import 'package:space_anywhere/models/comparison_models/info_object.dart';

class ComparisonWidget extends StatelessWidget {
  final String imagePath;
  final String objectName;
  //final InfoObject objectData;

  const ComparisonWidget({
    required this.imagePath,
    required this.objectName,
    //required this.objectData,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      color: Colors.red,
      child: Column(
        spacing: 10,
        children: <Widget>[
          Container(
            height: size.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white
            ),
            child: Center(
              child: FlutterLogo(size: 70, style: FlutterLogoStyle.stacked)
            )
          ),
          Divider(),
          Text("NOME", style: TextStyle(color: Colors.white)),
          Divider(),
          const SizedBox(height: 10),
          ...List.generate(5, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "DADOS: $index --- AAAAAAAAAAA",
                  style: TextStyle(color: Colors.white),
                )
              ]
            );
          })
        ]
      )
    );
  }
}
