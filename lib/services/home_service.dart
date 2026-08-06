import 'package:space_anywhere/controllers/curiosity_controller.dart';
import 'package:space_anywhere/services/db_service.dart';
import 'package:space_anywhere/core/di/app_dependencies.dart';
import 'package:space_anywhere/services/internet_service.dart';
import 'package:space_anywhere/models/database_models/curiosity_db_model.dart';

class HomeService {
  final int _curiosityId = 1;
  final _db = DatabaseService.instance();
  final CuriosityController _curiosityController = AppDependencies.curiosityController;
  late InternetService _internet;
  String _text = "";
  String _extraText = "";
  String _title = "";
  String _error = "";
  List<String> _fonts = [];
  CuriosityDbModel? _selectCuriosity;
  List<FontDbModel> _selectFonts = [];
  Future<void> Function()? _function;

  CuriosityController get curiosityController => _curiosityController;
  InternetService get internet => _internet;
  String get text => _text;
  String get extraText => _extraText;
  String get title => _title;
  String get error => _error;
  List<String> get fonts => _fonts;

  set generalError(String value) => _error = value;

  Future<void> getFunction({required Future<void> Function() func}) async {
    _function = func;
  }

  Future<void> initializeInternetInstance() async {
    if (_function == null) {
      throw Exception("É necessário receber a função service.");
    }
    _internet = InternetService.withoutFunctionParameter(function: _function!);
  }

  Future<bool> checkDatabaseIsNull() async {
    _selectCuriosity = await _db.selectCuriosity();
    _selectFonts = await _db.selectFonts();

    return _selectCuriosity == null;
  }

  String cleanText({required String text}) {
    return text
      .replaceAll('\\n', '\n')
      .replaceAll('\\r', '')
      .replaceAll('\\"', '"');
  }

  Future<void> getCuriosity({
    required int curiosityId,
    required DatabaseActions action,
  }) async {
    await _internet.hasInternet();

    if (!_internet.checkInternet) {
      return;
    }

    await _internet.isApiAwake();

    if (!_internet.checkAPI) {
      return;
    }

    await _curiosityController.onGetCuriosity(id: curiosityId);

    if (_curiosityController.getErrorCuriosity == null) {
      _text = cleanText(
        text: _curiosityController.getCuriosityModel!.shortAnswer,
      );
      _extraText = cleanText(
        text: _curiosityController.getCuriosityModel!.longAnswer,
      );
      _title = _curiosityController.getCuriosityModel!.title;
      _fonts = _curiosityController.getCuriosityModel!.contentFont;
      action == DatabaseActions.add
        ? await addCuriosity()
        : await updateCuriosity();
    } else {
      _error = _curiosityController.getErrorCuriosity!;
    }
  }

  Future<void> controlCuriosity() async {
    bool checkDatabaseEmpty = await checkDatabaseIsNull();

    if (!checkDatabaseEmpty) {
      if (DateTime.now().difference(DateTime.parse(_selectCuriosity!.time)).inHours >= 24) {
        await getCuriosity(
          curiosityId: _selectCuriosity!.curiosityId + 1,
          action: DatabaseActions.update,
        );
        return;
      }
      _fonts.clear();
      _internet.updateInternetStatus(status: true);
      _internet.updateAPIStatus(status: true);
      _text = cleanText(text: _selectCuriosity!.shortAnswer);
      _extraText = cleanText(text: _selectCuriosity!.longAnswer);
      _title = _selectCuriosity!.title;
      for (var font in _selectFonts) {
        _fonts.add(font.font);
      }
    } else {
      await getCuriosity(
        curiosityId: _curiosityId,
        action: DatabaseActions.add
      );
    }
  }

  Future<void> addCuriosity() async {
    final curiosityModel = CuriosityDbModel(
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

    await _db.addCuriosity(curiosityModel: curiosityModel);

    await addFonts();
  }

  Future<void> addFonts() async {
    int len = _curiosityController.getCuriosityModel!.contentFont.length;
    List<String> fonts = _curiosityController.getCuriosityModel!.contentFont;

    final List<FontDbModel> fontModel = List.generate(
      len,
      (index) => FontDbModel(font: fonts[index]),
    );

    for (var font in fontModel) {
      await _db.addFonts(fontModel: font);
    }
  }

  Future<void> updateCuriosity() async {
    final curiosityModel = CuriosityDbModel(
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

    await _db.updateCuriosity(
      curiosityModel: curiosityModel,
      previousCuriosityId: _selectCuriosity!.curiosityId
    );

    await _db.deleteFonts();

    await addFonts();
  }
}
