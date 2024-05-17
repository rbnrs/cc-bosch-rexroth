import 'package:poll_app/entity/option.dart';

import 'answer.dart';

enum QuestionType { singleSelection, multiSelection, textInput }

class Question {
  final String id;
  final String text;
  final String language;
  final QuestionType type;
  final List<Option> options;
  final List<Answer> answers;

  Question(
      this.id, this.text, this.language, this.type, this.options, this.answers);
}
