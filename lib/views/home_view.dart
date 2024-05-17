import 'package:flutter/material.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/poll.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/widgets/poll_list_item.dart';
import 'package:uuid/uuid.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Poll> polls = [];

  @override
  void initState() {
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

    polls.add(Poll(
        id: Uuid().v4(),
        name: 'My First Poll',
        description: 'This is a test for a poll in my dashboard',
        timestamp: DateTime.now(),
        questions: [question, question1]));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralFragments.createAppBar('Poll Dashboard', false, context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/createPoll');
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
          child: Center(
        child: ListView.builder(
            itemCount: polls.length,
            itemExtent: 150,
            itemBuilder: (context, index) {
              return PollListItem(
                poll: polls[index],
              );
            }),
      )),
    );
  }
}
