import 'package:flutter/material.dart';

class ExpansibleWidget extends StatelessWidget {
  final Widget header;
  final Widget body;
  final ExpansibleController controller;

  const ExpansibleWidget({
    required this.header,
    required this.body,
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expansible(
      controller: controller,
      headerBuilder: (context, _) => header,
      bodyBuilder: (context, _) => body
    );
  }
}
