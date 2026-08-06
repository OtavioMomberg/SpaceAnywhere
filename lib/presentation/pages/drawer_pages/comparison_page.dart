import 'package:flutter/material.dart';
import 'dart:math';
import 'package:space_anywhere/models/local_data_models/comparison_dataset.dart';
import 'package:space_anywhere/models/local_data_models/object_information.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';
import 'package:space_anywhere/presentation/widgets/comparison_widget.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  final ScrollController _scrollController = ScrollController();
  final List<ObjectInformation> finalList = [];
  final Random rand = Random();

  @override
  void initState() {
    super.initState();
    randomizeList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: ComparisonDataset.objects.length,
            itemExtent: size.width,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: AppTheme.borderRadius,
                  border: Border.all(
                    color: AppTheme.color1.withValues(alpha: 0.5),
                  ),
                  color: AppTheme.color1.withValues(alpha: 0.15),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => moveScroll(value: -size.width),
                      icon: Icon(Icons.arrow_back, color: AppTheme.color1),
                    ),
                    Expanded(
                      child: ComparisonWidget(
                        objectData: finalList[index].toList(), 
                        objectName: finalList[index].name,
                        imagePath: finalList[index].imagePath
                      ),
                    ),
                    IconButton(
                      onPressed: () => moveScroll(value: size.width),
                      icon: Icon(Icons.arrow_forward, color: AppTheme.color1)
                    )
                  ]
                )
              );
            }
          )
        )
      ]
    );
  }

  void randomizeList() {
    while (finalList.length < ComparisonDataset.objects.length) {
      int index = rand.nextInt(ComparisonDataset.objects.length);

      if (!finalList.contains(ComparisonDataset.objects[index])) {
        finalList.add(ComparisonDataset.objects[index]);
      }
    }
  }

  void moveScroll({required double value}) {
    _scrollController.animateTo(
      _scrollController.offset + value,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
