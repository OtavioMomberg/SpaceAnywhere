import 'package:space_anywhere/models/api_models/curiosity_model.dart';

abstract class CuriosityRepositoryHttp {
  Future<CuriosityModel?> getCuriosity(int id);
}