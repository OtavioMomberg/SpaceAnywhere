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

  factory CuriosityModel.fromMap({required Map<String, dynamic> map}) {
    List<dynamic> fonts = map["content_font"];
    return CuriosityModel(
      id: map["id"], 
      title: map["title"], 
      shortAnswer: map["short_answer"], 
      longAnswer: map["long_answer"], 
      contentFont: fonts.map((item) => item.toString()).toList(),
    );
  }

  factory CuriosityModel.fromJson({required String source}) => CuriosityModel.fromMap(map: jsonDecode(source));
}