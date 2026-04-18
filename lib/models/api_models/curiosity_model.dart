import 'dart:convert';

class CuriosityModel {
  int id;
  String title;
  String shortAnswer;
  String longAnswer;
  List<String> contentFont;

  CuriosityModel({
    required this.id,
    required this.title,
    required this.shortAnswer,
    required this.longAnswer,
    required this.contentFont,
  });

  factory CuriosityModel.fromMap(Map<String, dynamic> map) {
    return CuriosityModel(
      id: map["id"], 
      title: map["title"], 
      shortAnswer: map["short_answer"], 
      longAnswer: map["long_answer"], 
      contentFont: List<String>.from(map["content_font"] ?? []),
    );
  }

  factory CuriosityModel.fromJson(String source) => CuriosityModel.fromMap(jsonDecode(source));
}