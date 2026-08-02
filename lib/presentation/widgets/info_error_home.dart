import 'package:flutter/material.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';
import 'package:space_anywhere/presentation/widgets/stylized_container.dart';

class InfoErrorHome extends StatelessWidget {
  final String message;
  final IconData icon;
  final double height;

  const InfoErrorHome({
    required this.message,
    required this.icon,
    required this.height,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return StylizedContainer(
      height: height,
      child: Column(
        mainAxisAlignment: .center,
        children: <Widget>[
          Text(
            message,
            style: const TextStyle(
             color: AppTheme.color1,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 2,
            textAlign: TextAlign.center
          ),
          Icon(
            icon,
            color: AppTheme.color1,
            size: 40
          )
        ]
      )
    );
  }
}