import 'package:poll_app/entity/option.dart';
import 'package:poll_app/utils/app_service.dart';

import 'answer.dart';

enum QuestionType { singleSelection, multiSelection, textInput }

class Question {
  final String id;
  final String text;
  final String language;
  final QuestionType? type;
  final List<Option> options;
  final List<Answer> answers;

  Question(
      this.id, this.text, this.language, this.type, this.options, this.answers);

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> optionsJSON = [];
    List<Map<String, dynamic>> answerJSON = [];

    for (Option op in options) {
      optionsJSON.add(op.toJSON());
    }

    for (Answer an in answers) {
      answerJSON.add(an.toJSON());
    }

    return {
      "id": id,
      "text": text,
      "language": language,
      "type": AppService().getQuestionTypeAsString(type!),
      "options": optionsJSON,
      "answers": answerJSON
    };
  }

  static Question fromJson(Map<String, dynamic> questionJson) {
    List<Option> options = [];
    List optionsJson = questionJson['options'];

    for (Map<String, dynamic> element in optionsJson) {
      Option option = Option.fromJson(element);
      options.add(option);
    }

    QuestionType? questionType =
        AppService().getQuestionTypeFromString(questionJson["question_type"]);

    return Question(
      questionJson["_id"],
      questionJson["text"],
      questionJson['language'],
      questionType,
      options,
      [],
    );
  }
}
