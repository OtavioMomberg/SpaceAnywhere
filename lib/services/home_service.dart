import 'package:http/http.dart';
import 'package:space_anywhere/controllers/curiosity_controller.dart';
import 'package:space_anywhere/database/db_services.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/models/database_models/curiosity_db_model.dart';
import 'package:space_anywhere/repositories/implementations/curiosity_implementation_http.dart';

class HomeService {
  final _curiosityId = 2;
  final _dbInstance = DatabaseServices.instance();
  final CuriosityController _curiosityController = CuriosityController(CuriosityImplementationHttp(client: Client()));
  late Internet _internet;
  List<dynamic> _selectCuriosity = [];
  List<dynamic> _selectFonts = [];
  bool _showKnowMoreButton = false;
  bool _checkFunction = false;
  String _text = "";
  String _extraText = "";
  String _title = "";
  String _error = "";
  List<String> _fonts = [];
  Future<void> Function()? _function;

  static final _instance = HomeService._();
  HomeService._();
  factory HomeService.instance() => _instance;

  CuriosityController get curiosityController => _curiosityController;
  Internet get internet => _internet;
  bool get showKnowMoreButton => _showKnowMoreButton;
  String get text => _text;
  String get extraText => _extraText;
  String get title => _title;
  String get error => _error;
  List<String> get fonts => _fonts;

  set generalError(String value) => _error = value;

  Future<void> getFunction({required Future<void> Function() func}) async {
    if (_checkFunction) return;
    
    _function = func;
    _checkFunction = true;
  }

  Future<void> initializeInternetInstance() async {
    if (_function == null) throw Exception("É necessário receber a função service.");

    _internet = Internet.withoutParam(func: _function!);
  } 

  Future<bool> checkDatabaseIsNull() async {
    _selectCuriosity = await _dbInstance.select(getCuriosity: true);
    _selectCuriosity.map((item) => item as CuriosityDbModel);

    _selectFonts = await _dbInstance.select(getCuriosity: false);
    _selectFonts.map((item) => item as FontModel);

    return _selectCuriosity.isEmpty;
  }

  String cleanText({required String text}) {
    return text
      .replaceAll('\\n', '\n')
      .replaceAll('\\r', '')
      .replaceAll('\\"', '"');
  }

  Future<void> getCuriosity({required int curiosityId, required DatabaseActions action}) async {
    await _internet.hasInternet();

    if (!_internet.checkInternet) { return; }

    await _internet.isApiAwake();

    if (!_internet.checkAPI) { return; }

    await _curiosityController.onGetCuriosity(id: curiosityId);

    if (_curiosityController.getErrorCuriosity == null) {
      _text = cleanText(text: _curiosityController.getCuriosityModel!.shortAnswer);
      _extraText = cleanText(text: _curiosityController.getCuriosityModel!.longAnswer);
      _title = _curiosityController.getCuriosityModel!.title;
      _fonts = _curiosityController.getCuriosityModel!.contentFont;

      _showKnowMoreButton = true;
      action == DatabaseActions.add ? addToDatabase() : updateInDatabase();
    } else {
      _error = _curiosityController.getErrorCuriosity!;
    }
  }

  Future<void> controlCuriosity() async {
    bool checkDatabaseEmpty = await checkDatabaseIsNull();

    if (checkDatabaseEmpty) {
      await getCuriosity(curiosityId: _curiosityId, action: DatabaseActions.add);
    } else if (DateTime.now().difference(DateTime.parse(_selectCuriosity[0].time)).inHours >= 24) {
      await getCuriosity(curiosityId: _selectCuriosity[0].curiosityId + 1, action: DatabaseActions.update);
    } else {
      _internet.updateInternetStatus(status: true);
      _internet.updateAPIStatus(status: true);
      _showKnowMoreButton = true;
      _text = cleanText(text: _selectCuriosity[0].shortAnswer);
      _extraText = cleanText(text: _selectCuriosity[0].longAnswer);
      _title = _selectCuriosity[0].title;
      for (int i = 0; i < _selectFonts.length; i++) {
        _fonts.add(_selectFonts[i].font);
      }
    }
  }

  Future<void> addToDatabase() async {
    final curiosityModel = CuriosityDbModel(
      id: 0,
      curiosityId: _curiosityController.getCuriosityModel!.id,
      shortAnswer: cleanText(text: _curiosityController.getCuriosityModel!.shortAnswer),
      longAnswer: cleanText(text: _curiosityController.getCuriosityModel!.longAnswer),
      title: _curiosityController.getCuriosityModel!.title,
      time: DateTime.now().toIso8601String(),
    );

    await _dbInstance.add(
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

    for (int i = 0; i < _curiosityController.getCuriosityModel!.contentFont.length; i++) {
      await _dbInstance.add(
        curiosityModel: null,
        fontModel: fontModel[i],
        getCuriosity: false,
      );
    }
  }

  Future<void> updateInDatabase() async {
    final curiosityModel = CuriosityDbModel(
      id: _selectCuriosity[0].id,
      curiosityId: _curiosityController.getCuriosityModel!.id,
      shortAnswer: cleanText(text: _curiosityController.getCuriosityModel!.shortAnswer),
      longAnswer: cleanText(text: _curiosityController.getCuriosityModel!.longAnswer),
      title: _curiosityController.getCuriosityModel!.title,
      time: DateTime.now().toIso8601String(),
    );

    await _dbInstance.update(curiosityModel: curiosityModel);

    await _dbInstance.delete();

    await addFonts();
  }
}
