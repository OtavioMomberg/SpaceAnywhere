class InfoObject {
  String name = "";
  String diameter = "";
  String mass = "";
  String earthDistance = "";
  String objectType = "";
  String imagePath = "";
  double? gravityOverEarth;

  InfoObject({
    required this.name,
    required this.diameter,
    required this.mass,
    required this.earthDistance,
    required this.objectType,
    required this.imagePath
  });

  InfoObject.calculate({
    required this.name, 
    required double gravity
  }) : gravityOverEarth = gravity;
}