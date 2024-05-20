import 'package:poll_app/entity/question.dart';
import 'package:intl/intl.dart';

class Poll {
  final String id;
  final String name;
  final String description;
  final DateTime timestamp;
  final List<Question> questions;

  Poll(
      {required this.id,
      required this.name,
      required this.description,
      required this.timestamp,
      required this.questions});

  static createEmptyPoll() {
    return Poll(
        id: "",
        description: "",
        name: "",
        questions: [],
        timestamp: DateTime.now());
  }

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> questionList = [];

    for (Question q in questions) {
      questionList.add(q.toJSON());
    }

    return {
      "id": id,
      "description": description,
      "name": name,
      "questions": questionList
    };
  }

  static Poll fromJSON(Map<String, dynamic> json) {
    DateFormat dateformat = DateFormat('yyyy-MM-dd hh:mm:ss');

    List<Question> questions = [];
    List questionsJson = json['questions'];

    for (Map<String, dynamic> questionJson in questionsJson) {
      Question question = Question.fromJson(questionJson);
      questions.add(question);
    }

    return Poll(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        timestamp: dateformat.parse(json['timestamp']),
        questions: questions);
  }
}
