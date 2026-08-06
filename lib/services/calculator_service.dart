import 'package:space_anywhere/models/local_data_models/object_information.dart';
import 'package:space_anywhere/models/local_data_models/objects_gravity.dart';

class CalculatorService {
  static const String defaultOptionText = "Escolha um objeto";
  String _text = defaultOptionText;
  double? _result = 0.0;
  int _index = 0;
  final List<ObjectInformation> _planetsGravity = ObjectsGravity.planetsGravity;

  static final _instance = CalculatorService._();
  CalculatorService._();
  factory CalculatorService.instance() => _instance;

  List<ObjectInformation> get planetsGravity => List.unmodifiable(_planetsGravity); 
  String get defaultText => _text;
  double? get result => _result;

  void defineNewText({required int index}) {
    _text = _planetsGravity[index].name;
    _index = index;
  }

  void setDefaultText() => _text = defaultOptionText;

  void initializeResult() => _result = 0.0;

  void calculate({required String weight}) {
    if (weight.contains(".") || weight.contains(",")) {
      weight = weight.replaceAll(".", "").replaceAll(",", "");
    } else {
      weight = (int.parse(weight) * 100).toString();
    }

    final checkWeight = double.tryParse(weight);

    if (checkWeight == null) {
      _result = null;
      return;
    }
    _result = (checkWeight * _planetsGravity[_index].gravityOverEarth!) / 100;
  }
}
