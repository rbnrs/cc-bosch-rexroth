import 'dart:typed_data';

import 'package:poll_app/entity/question.dart';

class AppService {
  String getQuestionTypeAsString(QuestionType qt) {
    switch (qt) {
      case QuestionType.textInput:
        return 'text';
      case QuestionType.multiSelection:
        return 'multi';
      case QuestionType.singleSelection:
        return 'single';
    }
  }

  QuestionType? getQuestionTypeFromString(String type) {
    switch (type) {
      case 'single':
        return QuestionType.singleSelection;
      case 'multi':
        return QuestionType.multiSelection;
      case 'text':
        return QuestionType.textInput;
      default:
        return null;
    }
  }

  Future<void> downloadPicture(Uint8List pngBytes, String fileName) async {
    //TODO
  }
}
