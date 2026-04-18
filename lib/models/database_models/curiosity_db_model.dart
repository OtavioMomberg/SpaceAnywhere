class CuriosityDbModel {
  int id;
  int curiosityId;
  String title;
  String shortAnswer;
  String longAnswer;
  String time;

  CuriosityDbModel({
    required this.id,
    required this.curiosityId,
    required this.shortAnswer,
    required this.longAnswer,
    required this.title,
    required this.time
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "curiosity_id": curiosityId,
      "title": title,
      "short_answer": shortAnswer,
      "long_answer": longAnswer,
      "time": time
    };
  }
}