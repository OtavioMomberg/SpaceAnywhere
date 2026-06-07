import 'package:space_anywhere/models/api_models/curiosity_model.dart';

abstract interface class CuriosityRepositoryHttp {
  Future<CuriosityModel?> getCuriosity({required int id});
}