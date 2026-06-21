import "package:http/http.dart" as http;
import "package:space_anywhere/repositories/route/api_route.dart";

class Internet{
  final int _retryAttempts = 15;
  int _currentRetryAttempt = 0;
  bool _checkInternet = false;
  bool _checkAPI = false;
  dynamic _function;

  bool get checkInternet => _checkInternet;
  bool get checkAPI => _checkAPI;
  int get retryAttempts => _retryAttempts;
  int get currentRetryAttempt => _currentRetryAttempt;

  Future<bool> hasInternet() async {
    try {
      final url = "https://www.google.com";
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isApiAwake() async {
    try {
      final url = "$URL/health/";
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 60));
      return response.statusCode == 200;
    } catch(error) {
      return false;
    }
  }

  Future<void> verifyInternet() async {
    _checkInternet = await hasInternet();
  }

  Future<void> verifyAPI() async {
    _checkAPI = await isApiAwake();
  }

  void updateInternetStatus({required bool status}) => _checkInternet = status;
  void updateAPIStatus({required bool status}) => _checkAPI = status;

  void setFunction({required Future<void> Function() func}) {
    _function = func;
    return;
  }
  void setFunctionWithParam({required Future<void> Function({int? questionId}) funcWithParam}) {
    _function = funcWithParam;
    return;
  }
  
  Future<void> retryConnectionSystem() async {
    if (_function == null) return;

    _currentRetryAttempt = 0;
    while (_currentRetryAttempt < _retryAttempts) {
      await _function.call();

      if (checkInternet && checkAPI) { 
        _currentRetryAttempt = _retryAttempts;
        break; 
      }
      _currentRetryAttempt++;
    }
  }
}