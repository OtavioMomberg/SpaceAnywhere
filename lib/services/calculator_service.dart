import 'package:space_anywhere/models/local_data_models/info_object.dart';
import 'package:space_anywhere/models/local_data_models/planets_gravity.dart';

class CalculatorService {
  String _text = "Escolha um objeto";
  double? _result = 0.0;
  int _index = 0;
  final List<InfoObject> planetsGravity = PlanetsGravity.planetsGravity;

  static final _instance = CalculatorService._();
  CalculatorService._();
  factory CalculatorService.instance() => _instance;

  String get defaultText => _text;

  double? get result => _result;

  void defineNewText({required int index}) {
    _text = planetsGravity[index].name;
    _index = index;
  } 

  void setDefaultText() => _text = "Escolha um objeto";

  void initializeResult() => _result = 0.0;

  void calculate({required String weight}) {
    final checkWeight = double.tryParse(weight);

    if (checkWeight == null) { 
      _result = null;
      return;
    }
    _result = checkWeight * planetsGravity[_index].gravityOverEarth!;
  }
}