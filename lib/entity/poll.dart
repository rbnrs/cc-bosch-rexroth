import 'package:poll_app/entity/question.dart';

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
}
