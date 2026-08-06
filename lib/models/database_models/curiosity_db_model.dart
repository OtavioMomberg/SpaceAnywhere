class CuriosityDbModel {
  int curiosityId;
  String title;
  String shortAnswer;
  String longAnswer;
  String time;

  CuriosityDbModel({
    required this.curiosityId,
    required this.shortAnswer,
    required this.longAnswer,
    required this.title,
    required this.time,
  });
}

class FontDbModel {
  String font;

  FontDbModel({required this.font});
}
