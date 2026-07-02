import 'package:flutter/material.dart';
import 'dart:math';
import 'package:space_anywhere/models/local_data_models/comparison_dataset.dart';
import 'package:space_anywhere/models/local_data_models/info_object.dart';
import 'package:space_anywhere/widgets/comparison_widget.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  final ScrollController _scrollController = ScrollController();
  final List<InfoObject> finalList = [];
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
            itemCount: ComparisonDataset.objectList.length,
            itemExtent: size.width,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => moveScroll(value: -size.width),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 206, 206, 207),
                      ),
                    ),
                    Expanded(
                      child: ComparisonWidget(objectData: finalList[index]),
                    ),
                    IconButton(
                      onPressed: () => moveScroll(value: size.width),
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Color.fromARGB(255, 206, 206, 207),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void randomizeList() {
    while (finalList.length < ComparisonDataset.objectList.length) {
      int index = rand.nextInt(ComparisonDataset.objectList.length);

      if (!finalList.contains(ComparisonDataset.objectList[index])) {
        finalList.add(ComparisonDataset.objectList[index]);
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
