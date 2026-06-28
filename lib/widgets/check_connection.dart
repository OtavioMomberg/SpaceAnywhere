import 'package:flutter/material.dart';
import 'package:space_anywhere/widgets/info_error_home.dart';

class CheckConnection extends StatelessWidget {
  final bool isLoading;
  final bool checkInternet;
  final bool checkAPI;
  final double height;

  const CheckConnection({
    required this.isLoading,
    required this.checkInternet,
    required this.checkAPI,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          spacing: 10,
          children: <Widget>[
            const Text(
              "Carregando...", 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 206, 206, 207)
              )
            ),
            const CircularProgressIndicator.adaptive(
              backgroundColor: Color.fromARGB(255, 206, 206, 207)
            )
          ]
        )
      );
    }
    if (!checkInternet) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InfoErrorHome(
          message: "Erro. Sem conexão com a internet",
          icon: Icons.wifi_off,
          height: height
        )
      );
    }
    if (!checkAPI) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InfoErrorHome(
          message: "Erro. Não foi possível se conectar ao servidor",
          icon: Icons.dns,
          height: height
        )
      );
    }
    return const SizedBox.shrink();
  }
}
