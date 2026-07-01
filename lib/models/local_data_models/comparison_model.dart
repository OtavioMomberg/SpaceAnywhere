import 'package:space_anywhere/models/local_data_models/info_object.dart';

class ComparisonModel {
  static List<String> topics = [
    "Nome:",
    "Diâmetro:",
    "Massa:",
    "Distância para a Terra:",
    "Tipo de objeto:"
  ];
  static List<InfoObject> objectList = [
    InfoObject(
      name: "Mercurío", 
      diameter: "4.880 km", 
      mass: "3.30 x 10^23 kg", 
      earthDistance: "77 - 222 milhões de km", 
      objectType: "Planeta", 
      imagePath: "assets/images/Mercurio.png"
    ),
    InfoObject(
      name: "Vênus", 
      diameter: "12.104 km", 
      mass: "4.87 x 10^23 kg", 
      earthDistance: "38 - 261 milhões de km", 
      objectType: "Planeta", 
      imagePath: "assets/images/Venus.png"
    ),
    InfoObject(
      name: "Terra", 
      diameter: "12.756 km", 
      mass: "5.97 x 10^24 kg", 
      earthDistance: "0", 
      objectType: "Planeta", 
      imagePath: "assets/images/Terra.png"
    ),
    InfoObject(
      name: "Marte", 
      diameter: "6.792 km", 
      mass: "6.42 x 10^23 kg", 
      earthDistance: "56 - 401 milhões de km", 
      objectType: "Planeta", 
      imagePath: "assets/images/Marte.png"
    ),
    InfoObject(
      name: "Jupiter", 
      diameter: "142.984 km", 
      mass: "1.90  x 10^27 kg", 
      earthDistance: "588 - 968 milhões de km", 
      objectType: "Planeta", 
      imagePath: "assets/images/Jupiter.png"
    ),
    InfoObject(
      name: "Saturno", 
      diameter: "120.536 km", 
      mass: "5.68  x 10^26 kg", 
      earthDistance: "1.2 - 1.6 bilhão de km", 
      objectType: "Planeta", 
      imagePath: "assets/images/Saturno.png"
    ),
    InfoObject(
      name: "Urano", 
      diameter: "51.118 km", 
      mass: "8.68 x 10^25 kg", 
      earthDistance: "2.6 - 3.1 bilhões de km", 
      objectType: "Planeta", 
      imagePath: "assets/images/Urano.png"
    ),
    InfoObject(
      name: "Netuno", 
      diameter: "49.528 km", 
      mass: "1.02 x 10^26 kg", 
      earthDistance: "4.3 - 4.7 bilhões de km", 
      objectType: "Planeta", 
      imagePath: "assets/images/Netuno.png"
    ),
    InfoObject(
      name: "Plutão", 
      diameter: "2.377 km", 
      mass: "1.31 x 10^22 kg", 
      earthDistance: "4.28 - 7.5 bilhões de km", 
      objectType: "Planeta-Anão", 
      imagePath: "assets/images/Plutao.png"
    ),
    InfoObject(
      name: "Sol", 
      diameter: "1.392.000 km", 
      mass: "1.989 x 10^30 kg", 
      earthDistance: "147 - 152.1 milhões de km", 
      objectType: "Estrela", 
      imagePath: "assets/images/Sol.png"
    ),
  ];
}