import 'package:http/http.dart';
import 'package:space_anywhere/controllers/curiosity_controller.dart';
import 'package:space_anywhere/database/db_services.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/models/database_models/curiosity_db_model.dart';
import 'package:space_anywhere/repositories/implementations/curiosity_implementation_http.dart';

class HomeService {
  // attributes
  final _curiosityId = 2;
  final _dbInstance = DatabaseServices.instance();
  final CuriosityController _curiosityController = CuriosityController(
    CuriosityImplementationHttp(client: Client()),
  );
  List<dynamic> _selectCuriosity = [];
  List<dynamic> _selectFonts = [];
  bool _checkInternet = false;
  bool _checkAPI = false;
  bool _showKnowMoreButton = false;
  String _text = "";
  String _extraText = "";
  String _title = "";
  String _error = "";
  List<String> _fonts = [];

  // getters
  CuriosityController get curiosityController => _curiosityController;
  bool get checkInternet => _checkInternet;
  bool get checkAPI => _checkAPI;
  bool get showKnowMoreButton => _showKnowMoreButton;
  String get text => _text;
  String get extraText => _extraText;
  String get title => _title;
  String get error => _error;
  List<String> get fonts => _fonts;

  // instance
  static final _instance = HomeService._();
  HomeService._();

  factory HomeService.instance() => _instance;

  // check if the database is null method
  // select values from the curiosity table
  // set each item returned to [CuriosityDbModel] type
  // select values from the font table
  // set each item returned to [FontModel] type
  // return true if [_selectCuriosity] is empty; false otherwise
  Future<bool> checkDatabaseIsNull() async {
    _selectCuriosity = await _dbInstance.select(getCuriosity: true);
    _selectCuriosity.map((item) => item as CuriosityDbModel);

    _selectFonts = await _dbInstance.select(getCuriosity: false);
    _selectFonts.map((item) => item as FontModel);

    return _selectCuriosity.isEmpty;
  }

  // clean text recieved from the API method
  // clean the text (need to be improved)
  String cleanText({required String text}) {
    return text
      .replaceAll('\\n', '\n')
      .replaceAll('\\r', '')
      .replaceAll('\\"', '"');
  }

  // get curiosity method
  // check the internet [_checkInternet] and the API [_checkAPI]
  // the controller call the [onGetCuriosity] method
  // if there is no error attribute the values returned to the attributes 
  // call [addToDatabase()] or [updateInDatabase()] method
  // if there is an an error, attribute the error to [_error]
  Future<void> getCuriosity({required int curiosityId, required DatabaseActions action}) async {
    _checkInternet = await Internet.hasInternet();

    if (!_checkInternet) {
      return;
    }
    _checkAPI = await Internet.isApiAwake();

    if (!_checkAPI) {
      return;
    }
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

  // control curiosity method
  // check the database
  // if else block to verify the need of call the API or not and control the time
  Future<void> controlCuriosity() async {
    bool checkDatabaseEmpty = await checkDatabaseIsNull();

    if (checkDatabaseEmpty) {
      await getCuriosity(curiosityId: _curiosityId, action: DatabaseActions.add);
    } else if (DateTime.now().difference(DateTime.parse(_selectCuriosity[0].time)).inHours >= 24) {
      await getCuriosity(curiosityId: _selectCuriosity[0].curiosityId + 1, action: DatabaseActions.update);
    } else {
      _checkInternet = true;
      _checkAPI = true;
      _showKnowMoreButton = true;
      _text = cleanText(text: _selectCuriosity[0].shortAnswer);
      _extraText = cleanText(text: _selectCuriosity[0].longAnswer);
      _title = _selectCuriosity[0].title;
      for (int i = 0; i < _selectFonts.length; i++) {
        _fonts.add(_selectFonts[i].font);
      }
    }
  }

  // add curiosity data to curiosity table
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

  // add fonts data to font table
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

  // update curiosity data
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
