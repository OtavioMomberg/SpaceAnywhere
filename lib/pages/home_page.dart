import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:space_anywhere/controllers/curiosity_controller.dart';
import 'package:space_anywhere/database/db_services.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/models/database_models/curiosity_db_model.dart';
import 'package:space_anywhere/pages/extra_text_page.dart';
import 'package:space_anywhere/pages/fonts_page.dart';
import 'package:space_anywhere/repositories/implementations/curiosity_implementation_http.dart';
import 'package:space_anywhere/widgets/button.dart';
import 'package:space_anywhere/widgets/info_error_home.dart';
import 'package:space_anywhere/widgets/stylized_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbInstance = DatabaseServices.instance();
  final curiosityId = 2;
  late final CuriosityController _curiosityController;
  List<dynamic> selectCuriosity = [];
  List<dynamic> selectFonts = [];
  bool isLoading = true;
  bool showInternetError = false;
  bool checkInternet = false;
  bool checkAPI = false;
  bool showKnowMoreButton = false;
  String text = "";
  String extraText = "";
  String title = "";
  List<String> fonts = [];
  String error = "";

  @override
  void initState() {
    super.initState();

    _curiosityController = CuriosityController(
      CuriosityImplementationHttp(client: Client()),
    );

    controlCuriosity();
  }

  Future<bool> checkDatabaseIsNull() async {
    selectCuriosity = await dbInstance.select(getCuriosity: true);
    selectCuriosity.map((item) => item as CuriosityDbModel);

    selectFonts = await dbInstance.select(getCuriosity: false);
    selectFonts.map((item) => item as FontModel);

    return selectCuriosity.isEmpty ? true : false;
  }

  String cleanText({required String text}) {
    return text
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '')
        .replaceAll('\\"', '"');
  }

  Future<void> verifyInternet() async {
    checkInternet = await Internet.hasInternet();
  }

  Future<void> getCuriosity({
    required int curiosityId,
    required DatabaseActions action,
  }) async {
    await verifyInternet();

    if (!checkInternet) {
      if (!mounted) { return; }
      setState(() => isLoading = false);
      return;
    }

    checkAPI = await Internet.isApiAwake();

    if (!checkAPI) {
      if (!mounted) { return; }
      setState(() => isLoading = false);
      return;
    }

    await _curiosityController.onGetCuriosity(id: curiosityId);

    if (_curiosityController.getErrorCuriosity == null) {
      text = cleanText(
        text: _curiosityController.getCuriosityModel!.shortAnswer,
      );
      extraText = cleanText(
        text: _curiosityController.getCuriosityModel!.longAnswer,
      );
      title = _curiosityController.getCuriosityModel!.title;
      fonts = _curiosityController.getCuriosityModel!.contentFont;

      showKnowMoreButton = true;
      action == DatabaseActions.add ? addToDatabase() : updateInDatabase();
    } else {
      error = _curiosityController.getErrorCuriosity!;
    }
  }

  Future<void> controlCuriosity() async {
    bool checkDatabaseEmpty = await checkDatabaseIsNull();

    if (checkDatabaseEmpty) {
      await getCuriosity(curiosityId: curiosityId, action: DatabaseActions.add);
    } else if (DateTime.now().difference(DateTime.parse(selectCuriosity[0].time)).inHours >= 24) {
      await getCuriosity(
        curiosityId: selectCuriosity[0].curiosityId + 1,
        action: DatabaseActions.update,
      );
    } else {
      checkInternet = true;
      checkAPI = true;
      showKnowMoreButton = true;
      text = cleanText(text: selectCuriosity[0].shortAnswer);
      extraText = cleanText(text: selectCuriosity[0].longAnswer);
      title = selectCuriosity[0].title;
      for (int i = 0; i < selectFonts.length; i++) {
        fonts.add(selectFonts[i].font);
      }
    }
    if (!mounted) { return; }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addToDatabase() async {
    final curiosityModel = CuriosityDbModel(
      id: 0,
      curiosityId: _curiosityController.getCuriosityModel!.id,
      shortAnswer: cleanText(
        text: _curiosityController.getCuriosityModel!.shortAnswer,
      ),
      longAnswer: cleanText(
        text: _curiosityController.getCuriosityModel!.longAnswer,
      ),
      title: _curiosityController.getCuriosityModel!.title,
      time: DateTime.now().toIso8601String(),
    );

    await dbInstance.add(
      curiosityModel: curiosityModel,
      fontModel: null,
      getCuriosity: true,
    );

    await addFonts();
  }

  Future<void> addFonts() async {
    final List<FontModel> fontModel = List.generate(
      _curiosityController.getCuriosityModel!.contentFont.length,
      (index) => FontModel(
        font: _curiosityController.getCuriosityModel!.contentFont[index],
      ),
    );

    for (
      int i = 0;
      i < _curiosityController.getCuriosityModel!.contentFont.length;
      i++
    ) {
      await dbInstance.add(
        curiosityModel: null,
        fontModel: fontModel[i],
        getCuriosity: false,
      );
    }
  }

  Future<void> updateInDatabase() async {
    final curiosityModel = CuriosityDbModel(
      id: selectCuriosity[0].id,
      curiosityId: _curiosityController.getCuriosityModel!.id,
      shortAnswer: cleanText(
        text: _curiosityController.getCuriosityModel!.shortAnswer,
      ),
      longAnswer: cleanText(
        text: _curiosityController.getCuriosityModel!.longAnswer,
      ),
      title: _curiosityController.getCuriosityModel!.title,
      time: DateTime.now().toIso8601String(),
    );

    await dbInstance.update(curiosityModel: curiosityModel);

    await dbInstance.delete();

    await addFonts();
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
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        if (isLoading)...[
          StylizedContainer(
            height: size.height * 0.6,
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Color.fromARGB(255, 206, 206, 207),
            ),
          ),
        ] else if (!checkInternet)...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InfoErrorHome(
              message: "Erro. Sem conexão com a internet",
              icon: Icons.wifi_off,
              height: size.height * 0.6,
            ),
          ),
        ] else if (!checkAPI)...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InfoErrorHome(
              message: "Erro. Não foi possível se conectar ao servidor",
              icon: Icons.dns,
              height: size.height * 0.6,
            ),
          ),
        ] else if (_curiosityController.getErrorCuriosity == null)...[
          Flexible(
            child: FractionallySizedBox(
              heightFactor: 0.9,
              child: StylizedContainer(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 15,
                    children: <Widget>[
                      if (_curiosityController.getErrorCuriosity == null)...[
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 206, 206, 207),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          text,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 206, 206, 207),
                            height: 1.7,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ] else...[
          Text(
            error,
            style: const TextStyle(color: Color.fromARGB(255, 206, 206, 207)),
            textAlign: TextAlign.center,
          ),
        ],
        if (showKnowMoreButton)...[
          Row(
            mainAxisAlignment: .center,
            spacing: 10,
            children: <Widget>[
              Expanded(
                child: Button(
                  label: "Saiba Mais",
                  function: goNextPage,
                  pageIndex: 0,
                ),
              ),
              Expanded(
                child: Button(
                  label: "Fontes",
                  function: goNextPage,
                  pageIndex: 1,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void goNextPage({int? n}) {
    final int? pageIndex = n;
    if (pageIndex == null) { return; }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => pageIndex == 0
            ? ExtraTextPage(title: title, text: extraText)
            : FontsPage(fonts: fonts),
        transitionsBuilder: (_, animation, _, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
