import 'package:space_anywhere/models/api_models/curiosity_model.dart';
import 'package:space_anywhere/repositories/curiosity_repository_http.dart';

class CuriosityController {
  final CuriosityRepositoryHttp curiosityRepositoryHttp;

  CuriosityController(this.curiosityRepositoryHttp);

  String? _errorGetCuriosity;

  String? get getErrorCuriosity => _errorGetCuriosity;

  bool _isLoading = true;

  bool get getIsLoading => _isLoading;

  CuriosityModel? _curiosityModel;

  CuriosityModel? get getCuriosityModel => _curiosityModel;

  Future<void> onGetCuriosity(int id) async {
    _errorGetCuriosity = null;
    _isLoading = true;
    try {
      final response = await curiosityRepositoryHttp.getCuriosity(id);

      if (response != null) _curiosityModel = response;

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorGetCuriosity = split[split.length-2];
    }
    _isLoading = false;
  }
}