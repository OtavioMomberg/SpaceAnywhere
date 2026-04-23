import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:ui';
import 'package:space_anywhere/controllers/curiosity_controller.dart';
import 'package:space_anywhere/database/db_services.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/models/database_models/curiosity_db_model.dart';
import 'package:space_anywhere/pages/extra_text_page.dart';
import 'package:space_anywhere/repositories/implementations/curiosity_implementation_http.dart';
import 'package:space_anywhere/themes/app_theme.dart';
import 'package:space_anywhere/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbInstance = DbServices.instance();
  final curiosityId = 2;
  late final CuriosityController curiosityController;
  List<CuriosityDbModel> selectCuriosity = [];
  bool isLoading = true;
  bool showInternetError = false;
  bool checkInternet = false;
  bool showKnowMoreButton = false;
  String text = "";
  String extraText = "";
  String title = "";
  String error = "";

  @override
  void initState() {
    super.initState();

    curiosityController = CuriosityController(
      CuriosityImplementationHttp(client:  Client())
    );

    controlCuriosity();
  }

  Future<bool> checkDatabaseIsNull() async {
    selectCuriosity = await dbInstance.select();

    return selectCuriosity.isEmpty ? true : false;
  }

  String cleanText(String text) {
    return text
      .replaceAll('\\n', '\n')
      .replaceAll('\\r', '')
      .replaceAll('\\"', '"');
  }

  Future<void> getCuriosity(int curiosityId, DbActions action) async {
    await verifyInternet();

    if (!checkInternet) return;

    await curiosityController.onGetCuriosity(curiosityId);

    if (curiosityController.getErrorCuriosity == null) {
      text = cleanText(curiosityController.getCuriosityModel!.shortAnswer); 
      extraText = cleanText(curiosityController.getCuriosityModel!.longAnswer);    
      title = curiosityController.getCuriosityModel!.title;

      showKnowMoreButton = true;

      action == DbActions.add ? addCuriosityToDatabase() : updateCuriosityInDatabase();
    } else {
      error = curiosityController.getErrorCuriosity!;
    }
  }

  Future<void> verifyInternet() async {
    checkInternet = await Internet.hasInternet();
  }

  Future<void> controlCuriosity() async {
    bool checkDatabaseEmpty = await checkDatabaseIsNull();

    if (checkDatabaseEmpty) {
      await getCuriosity(curiosityId, DbActions.add);
    } else if (DateTime.now().difference(DateTime.parse(selectCuriosity[0].time)).inHours >= 24) {
      await getCuriosity(selectCuriosity[0].curiosityId+1, DbActions.update);
    } else {
      checkInternet = true;
      showKnowMoreButton = true;
      text = cleanText(selectCuriosity[0].shortAnswer);
      extraText = cleanText(selectCuriosity[0].longAnswer); 
      title = selectCuriosity[0].title;
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addCuriosityToDatabase() async {
    final curiosityModel = CuriosityDbModel(
      id: 0, 
      curiosityId: curiosityController.getCuriosityModel!.id, 
      shortAnswer: cleanText(curiosityController.getCuriosityModel!.shortAnswer), 
      longAnswer: cleanText(curiosityController.getCuriosityModel!.longAnswer), 
      title: curiosityController.getCuriosityModel!.title, 
      time: DateTime.now().toIso8601String()
    );

    await dbInstance.add(curiosityModel);
  }

  Future<void> updateCuriosityInDatabase() async {
    final curiosityModel = CuriosityDbModel(
      id: selectCuriosity[0].id, 
      curiosityId: curiosityController.getCuriosityModel!.id, 
      shortAnswer: cleanText(curiosityController.getCuriosityModel!.shortAnswer), 
      longAnswer: cleanText(curiosityController.getCuriosityModel!.longAnswer), 
      title: curiosityController.getCuriosityModel!.title, 
      time: DateTime.now().toIso8601String()
    );

    await dbInstance.update(curiosityModel);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(gradient: AppTheme.mainGradient),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Curiosidade do Dia", 
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 207), 
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ), 
              textAlign: TextAlign.center
            ),
            Center(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    height: size.height * 0.70,
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      color: Colors.white.withValues(alpha: 0.15)
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 15,
                        children: <Widget>[
                          if (isLoading)...[
                            CircularProgressIndicator(
                              color: Colors.white.withValues(alpha: 0.5)
                            )
                          ] else if (!checkInternet)...[
                            Text(
                              "Erro. Sem conexão com a internet", 
                              style: const TextStyle(
                                color: Color.fromARGB(255, 206, 206, 207), 
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ), 
                              maxLines: 2,
                              textAlign: TextAlign.center
                            ),
                            const Icon(Icons.wifi_off, color: Color.fromARGB(255, 206, 206, 207), size: 40)
                          ] else if (curiosityController.getErrorCuriosity == null)...[
                            Text(
                              title, 
                              style: const TextStyle(
                                color: Color.fromARGB(255, 206, 206, 207), 
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ), 
                              maxLines: 2,
                              textAlign: TextAlign.center
                            ),
                            Text(
                              text, 
                              style: const TextStyle(
                                color: Color.fromARGB(255, 206, 206, 207),
                                height: 1.7
                              ), 
                              textAlign: TextAlign.justify
                            )
                          ] else...[
                            Text(
                              error, 
                              style: const TextStyle(color: Color.fromARGB(255, 206, 206, 207)), 
                              textAlign: TextAlign.center
                            )
                          ]
                        ]
                      )
                    )
                  )
                )
              )
            ),
            if (showKnowMoreButton)
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Button(label: "Saiba Mais", goExtraTextPage: goExtraTextPage)
              )
          ]
        )
      )
    );
  }

  void goExtraTextPage() {
    Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (_, _, _) => ExtraTextPage(title: title, text: extraText),
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
