import 'package:flutter/material.dart';
import 'package:space_anywhere/pages/extra_text_page.dart';
import 'package:space_anywhere/pages/fonts_page.dart';
import 'package:space_anywhere/services/home_services.dart';
import 'package:space_anywhere/widgets/button.dart';
import 'package:space_anywhere/widgets/check_connection.dart';
import 'package:space_anywhere/widgets/stylized_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeServices = HomeServices.instance();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controlCuriosity();
  }

  Future<void> controlCuriosity() async {
    await _homeServices.controlCuriosity();

    if (!mounted) {
      return;
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      spacing: 20,
      mainAxisAlignment: .start,
      children: <Widget>[
        Text(
          "Curiosidade do Dia",
          style: const TextStyle(
            color: Color.fromARGB(255, 206, 206, 207),
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
          textAlign: TextAlign.center
        ),
        if (isLoading)...[
          StylizedContainer(
            height: size.height * 0.6,
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Color.fromARGB(255, 206, 206, 207)
            )
          ),
        ] else if (!_homeServices.checkInternet || !_homeServices.checkAPI)...[
          CheckConnection(
            checkInternet: _homeServices.checkInternet,
            checkAPI: _homeServices.checkAPI,
            height: size.height * 0.6,
          ),
        ] else if (_homeServices.curiosityController.getErrorCuriosity == null)...[
          Flexible(
            child: FractionallySizedBox(
              heightFactor: 0.9,
              child: StylizedContainer(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 15,
                    children: <Widget>[
                      Text(
                        _homeServices.title,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 206, 206, 207),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center
                      ),
                      Text(
                        _homeServices.text,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 206, 206, 207),
                          height: 1.7,
                        ),
                        textAlign: TextAlign.justify
                      )
                    ]
                  )
                )
              )
            )
          )
        ] else...[
          Text(
            _homeServices.error,
            style: const TextStyle(color: Color.fromARGB(255, 206, 206, 207)),
            textAlign: TextAlign.center
          )
        ],
        if (_homeServices.showKnowMoreButton)...[
          Row(
            mainAxisAlignment: .center,
            spacing: 10,
            children: <Widget>[
              Expanded(
                child: Button(
                  label: "Saiba Mais",
                  function: goNextPage,
                  pageIndex: 0
                )
              ),
              Expanded(
                child: Button(
                  label: "Fontes",
                  function: goNextPage,
                  pageIndex: 1
                )
              )
            ]
          )
        ]
      ]
    );
  }

  void goNextPage({int? index}) {
    final int? pageIndex = index;
    if (pageIndex == null) {
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => pageIndex == 0
            ? ExtraTextPage(
                title: _homeServices.title,
                text: _homeServices.extraText,
              )
            : FontsPage(fonts: _homeServices.fonts),
        transitionsBuilder: (_, animation, _, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child
          );
        }
      )
    );
  }
}
