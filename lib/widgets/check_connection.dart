import 'package:flutter/material.dart';
import 'package:space_anywhere/widgets/info_error_home.dart';

class CheckConnection extends StatelessWidget {
  final bool checkInternet;
  final bool checkAPI;
  final double height;

  const CheckConnection({
    required this.checkInternet, 
    required this.checkAPI, 
    required this.height,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    if (!checkInternet){
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InfoErrorHome(message: "Erro. Sem conexão com a internet", icon: Icons.wifi_off, height: height)
      );
    } 
    if (!checkAPI){
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InfoErrorHome(message: "Erro. Não foi possível se conectar ao servidor", icon: Icons.dns, height: height)
      );
    }      
    return const SizedBox.shrink();   
  }
}