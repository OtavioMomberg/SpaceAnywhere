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
    required this.time
  });

  Map<String, dynamic> toMap() {
    return {
      "curiosity_id": curiosityId,
      "title": title,
      "short_answer": shortAnswer,
      "long_answer": longAnswer,
      "time": time
    };
  }
}

class FontModel {
  String font;

  FontModel({
    required this.font
  });
}