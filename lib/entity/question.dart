import 'answer.dart';

enum QuestionType {
  singleSelection, multiSelection, textInput
}

class Question {
 late String _id;
 late String _text;
 late String _language;
 late QuestionType _type;
 late List<Answer> _answers;
}