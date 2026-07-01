import 'package:space_anywhere/models/local_data_models/info_object.dart';

class PlanetsGravity {
  static final List<InfoObject> planetsGravity = [
    InfoObject.calculate(name: "Mercúrio", gravity: 0.38),
    InfoObject.calculate(name: "Vênus", gravity: 0.90),
    InfoObject.calculate(name: "Terra", gravity: 1.0),
    InfoObject.calculate(name: "Marte", gravity: 0.38),
    InfoObject.calculate(name: "Júpiter", gravity: 2.53),
    InfoObject.calculate(name: "Saturno", gravity: 1.06),
    InfoObject.calculate(name: "Urano", gravity: 0.89),
    InfoObject.calculate(name: "Netuno", gravity: 1.14),
    InfoObject.calculate(name: "Plutão", gravity: 0.063),
    InfoObject.calculate(name: "Lua", gravity: 0.166),
    InfoObject.calculate(name: "Europa", gravity: 0.134),
    InfoObject.calculate(name: "Titã", gravity: 0.138)
  ];
}