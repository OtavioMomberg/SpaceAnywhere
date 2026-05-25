import 'package:flutter/material.dart';
import 'package:space_anywhere/models/comparison_models/comparison_model.dart';
import 'package:space_anywhere/widgets/comparison_widget.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: ComparisonModel.objectList.length,
            itemExtent: size.width,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                  color: Colors.white.withValues(alpha: 0.15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => moveScroll(-size.width), 
                      icon: Icon(Icons.arrow_back, color: Colors.white)
                    ),
                    Expanded(
                      child: ComparisonWidget(
                        objectData: ComparisonModel.objectList[index]
                      )
                    ),
                    IconButton(
                      onPressed: () => moveScroll(size.width), 
                      icon: Icon(Icons.arrow_forward, color: Colors.white)
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

  void moveScroll(double value) {
    _scrollController.animateTo(
      _scrollController.offset + value, 
      duration: Duration(milliseconds: 500), 
      curve: Curves.easeOut
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}