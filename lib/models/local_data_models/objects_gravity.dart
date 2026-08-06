import 'package:space_anywhere/models/local_data_models/object_information.dart';

class ObjectsGravity {
  static const List<ObjectInformation> planetsGravity = [
    ObjectInformation.calculate(name: "Mercúrio", gravityOverEarth: 0.38),
    ObjectInformation.calculate(name: "Vênus", gravityOverEarth: 0.90),
    ObjectInformation.calculate(name: "Terra", gravityOverEarth: 1.0),
    ObjectInformation.calculate(name: "Marte", gravityOverEarth: 0.38),
    ObjectInformation.calculate(name: "Júpiter", gravityOverEarth: 2.53),
    ObjectInformation.calculate(name: "Saturno", gravityOverEarth: 1.06),
    ObjectInformation.calculate(name: "Urano", gravityOverEarth: 0.89),
    ObjectInformation.calculate(name: "Netuno", gravityOverEarth: 1.14),
    ObjectInformation.calculate(name: "Plutão", gravityOverEarth: 0.063),
    ObjectInformation.calculate(name: "Lua", gravityOverEarth: 0.166),
    ObjectInformation.calculate(name: "Europa", gravityOverEarth: 0.134),
    ObjectInformation.calculate(name: "Titã", gravityOverEarth: 0.138),
  ];
}
