import 'package:space_anywhere/models/api_models/curiosity_model.dart';
import 'package:space_anywhere/repositories/curiosity_repository_http.dart';

class CuriosityController {
  final CuriosityRepositoryHttp _curiosityRepositoryHttp;

  CuriosityController(this._curiosityRepositoryHttp);

  String? _errorGetCuriosity;

  String? get getErrorCuriosity => _errorGetCuriosity;

  CuriosityModel? _curiosityModel;

  CuriosityModel? get getCuriosityModel => _curiosityModel;

  Future<void> onGetCuriosity({required int id}) async {
    _errorGetCuriosity = null;
    try {
      final response = await _curiosityRepositoryHttp.getCuriosity(id: id);

      if (response != null) { _curiosityModel = response; }

    } catch(error) {
      _errorGetCuriosity = error.toString();
    }
  }
}