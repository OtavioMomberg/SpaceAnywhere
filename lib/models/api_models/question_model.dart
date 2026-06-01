import 'dart:convert';

class QuestionModel {
  int id;
  String question;
  List<String> alternatives;
  int rightAnswerIndex;

  QuestionModel({
    required this.id,
    required this.question,
    required this.alternatives,
    required this.rightAnswerIndex
  });

  factory QuestionModel.fromMap({required Map<String, dynamic> map}) {
    List<dynamic> alternatives = map["alternatives"];
    return QuestionModel(
      id: map["id"], 
      question: map["question"], 
      alternatives: alternatives.map((item) => item.toString()).toList(), 
      rightAnswerIndex: map["right_answer_index"]
    );
  }

  factory QuestionModel.fromJson({required String source}) => QuestionModel.fromMap(map: jsonDecode(source));
}