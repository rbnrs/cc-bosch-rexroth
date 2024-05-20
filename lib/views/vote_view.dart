import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poll_app/entity/answer.dart';
import 'package:poll_app/entity/poll.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/utils/custom_styles.dart';
import 'package:poll_app/utils/poll_service_handler.dart';
import 'package:poll_app/widgets/question_list_vote_item.dart';
import 'package:uuid/uuid.dart';

class VoteView extends StatefulWidget {
  final String pollId;

  const VoteView({super.key, required this.pollId});

  @override
  State<VoteView> createState() => _VoteViewState();
}

class _VoteViewState extends State<VoteView> {
  bool bThankYouScreen = false;
  String userIp = "";

  Map<String, Answer> answers = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Poll poll = snapshot.data!;
          return !bThankYouScreen
              ? Scaffold(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  body: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: CustomStyles.formControlMargin,
                        ),
                      ),
                      SliverToBoxAdapter(child: createPollHeader(poll)),
                      SliverToBoxAdapter(
                        child: createVoteList(poll),
                      ),
                      SliverToBoxAdapter(
                        child: createSendAnswerButton(),
                      )
                    ],
                  ),
                )
              : Scaffold(body: createThankYouScreen());
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget createVoteList(Poll poll) {
    List<Widget> voteListItems = [];

    SizedBox sizedBox = const SizedBox(
      height: CustomStyles.formElementMargin,
    );

    for (Question question in poll.questions) {
      voteListItems.add(sizedBox);
      voteListItems.add(
        QuestionListVoteItem(
          key: Key(question.id),
          question: question,
          onVote: (Question q, String optionId) async {
            http.Response response =
                await http.get(Uri.parse('https://api.ipify.org/?format=json'));

            Map<String, dynamic> responseContent = jsonDecode(response.body);
            String userIp = responseContent['ip'];

            Answer answer = Answer(
                answerId: const Uuid().v1(),
                pollId: widget.pollId,
                questionId: q.id,
                answer: optionId,
                answerBy: userIp);

            answers[q.id] = answer;
          },
        ),
      );
    }

    return Column(
      children: voteListItems,
    );
  }

  Widget createPollHeader(Poll poll) {
    return Container(
      margin: const EdgeInsets.all(CustomStyles.formElementMargin),
      padding: const EdgeInsets.all(CustomStyles.formElementMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CustomStyles.itemBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            poll.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: CustomStyles.formElementMargin / 2,
          ),
          Text(
            poll.description,
          ),
        ],
      ),
    );
  }

  Widget createSendAnswerButton() {
    return Container(
      height: CustomStyles.buttonHeight,
      margin: const EdgeInsets.all(CustomStyles.formElementMargin),
      child: ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) {
                return GeneralFragments.createLoadingDialog(context);
              },
            );
            await sendVotes();
            Navigator.of(context).pop();
            showThankYouScreen();
          },
          child: const Text("Vote")),
    );
  }

  Future<void> sendVotes() async {
    List<String> keys = answers.keys.toList();
    for (String key in keys) {
      await PollServiceHandler().onVoteForPoll(answers[key]!);
    }
  }

  void showThankYouScreen() {
    bThankYouScreen = true;
    setState(() {});
  }

  Widget createThankYouScreen() {
    return Center(
      child: Text(
        "Thanks for voting!",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Future<Poll> _loadData() async {
    bThankYouScreen = await PollServiceHandler().checkForVote(widget.pollId);

    return await PollServiceHandler().onLoadPollById(widget.pollId);
  }
}
