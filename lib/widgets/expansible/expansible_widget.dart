import 'package:flutter/material.dart';
import 'package:space_anywhere/widgets/expansible/expansible_body.dart';
import 'package:space_anywhere/widgets/expansible/expansible_header.dart';

class ExpansibleWidget extends StatelessWidget {
  final ExpansibleController controller;
  final VoidCallback setStateCallback;

  const ExpansibleWidget({
    required this.controller,
    required this.setStateCallback,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expansible(
      controller: controller,
      headerBuilder: (context, _) => ExpansibleHeader(controller: controller),
      bodyBuilder: (context, _) => ExpansibleBody(controller: controller, setStateCallback: setStateCallback)
    );
  }
}
