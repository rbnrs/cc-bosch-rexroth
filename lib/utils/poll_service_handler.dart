import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/poll.dart';
import 'package:poll_app/entity/question.dart';
import 'package:uuid/uuid.dart';

class PollServiceHandler {
  Future<bool> onSavePoll(
      String pollName, String pollDescr, List<Question> questions) async {
    //TODO
    return true;
  }

  Future<Poll> onLoadPollById(String id) async {
    //TODO remove
    List<Option> options = [
      Option('', '', '', false, false, 'Green'),
      Option('', '', '', false, false, 'Blue'),
      Option('', '', '', false, false, 'Yellow'),
      Option('', '', '', false, false, 'Red'),
      Option('', '', '', false, false, 'Black')
    ];

    Question question = Question(Uuid().v1(), 'What is your favorite color?',
        'EN', QuestionType.multiSelection, options, []);

    options = [
      Option('', '', '', false, false, 'Herr'),
      Option('', '', '', false, false, 'Frau'),
    ];

    Question question1 = Question(Uuid().v1(), 'Anrede?', 'EN',
        QuestionType.singleSelection, options, []);

    return Poll(
        id: Uuid().v4(),
        name: 'My First Poll',
        description: 'This is a test for a poll in my dashboard',
        timestamp: DateTime.now(),
        questions: [question, question1]);
  }
}
