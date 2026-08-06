import "package:http/http.dart" as http;
import "package:space_anywhere/core/constants/api_constants.dart";

class InternetService {
  final int _retryAttempts = 15;
  int _currentRetryAttempt = 0;
  bool _checkInternet = false;
  bool _checkAPI = false;
  int? _questionId;
  Future<void> Function({int? questionId})? _functionWithParam;
  Future<void> Function()? _function;

  InternetService.withFunctionParameter({
    required Future<void> Function({int? questionId}) function,
  }) : _functionWithParam = function;

  InternetService.withoutFunctionParameter({
    required Future<void> Function() function,
  }) : _function = function;

  bool get checkInternet => _checkInternet;
  bool get checkAPI => _checkAPI;
  int get retryAttempts => _retryAttempts;
  int get currentRetryAttempt => _currentRetryAttempt;

  set sendQuestionId(int? value) => _questionId = value;

  Future<void> hasInternet() async {
    try {
      final url = "https://www.google.com";
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
      _checkInternet = response.statusCode == 200;
    } catch (e) {
      _checkInternet = false;
    }
  }

  Future<void> isApiAwake() async {
    try {
      final url = "$URL/health/";
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 60));
      _checkAPI = response.statusCode == 200;
    } catch (error) {
      _checkAPI = false;
    }
  }

  void updateInternetStatus({required bool status}) => _checkInternet = status;

  void updateAPIStatus({required bool status}) => _checkAPI = status;

  Future<void> retryConnectionSystem() async {
    _currentRetryAttempt = 0;
    while (_currentRetryAttempt < _retryAttempts) {
      await _function!();

      if (checkInternet && checkAPI) {
        _currentRetryAttempt = _retryAttempts;
        break;
      }
      _currentRetryAttempt++;
    }
  }

  Future<void> retryConnectionSystemWithParam() async {
    _currentRetryAttempt = 0;
    while (_currentRetryAttempt < _retryAttempts) {
      await _functionWithParam!(questionId: _questionId);

      if (checkInternet && checkAPI) {
        _currentRetryAttempt = _retryAttempts;
        break;
      }
      _currentRetryAttempt++;
    }
  }
}
