import 'package:flutter/material.dart';
import 'package:poll_app/entity/poll.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/utils/app_status.dart';
import 'package:poll_app/utils/poll_service_handler.dart';
import 'package:poll_app/views/add_question_view.dart';
import 'package:poll_app/widgets/question_list_item.dart';
import 'package:poll_app/widgets/question_result_item.dart';

class PollDetailView extends StatefulWidget {
  final String pollId;

  const PollDetailView({super.key, required this.pollId});

  @override
  State<PollDetailView> createState() => _PollDetailViewState();
}

class _PollDetailViewState extends State<PollDetailView> {
  Poll poll = AppStatus.currentPoll;
  final double _formElementMargin = 15;
  final double _formControlMargin = 30;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PollServiceHandler().onLoadPollById(widget.pollId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Poll poll = snapshot.data!;
          return Scaffold(
            appBar:
                GeneralFragments.createAppBar('Poll Overview', true, context),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: _formElementMargin,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      createPollHeader(poll),
                      const Spacer(),
                      createShareView(poll),
                      SizedBox(
                        width: _formControlMargin,
                      )
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: createPollChart(poll),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget createPollHeader(Poll poll) {
    return Container(
      margin: EdgeInsets.all(_formElementMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            poll.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(
            height: _formElementMargin / 2,
          ),
          Text(
            poll.id,
          ),
          SizedBox(
            height: _formElementMargin * 2,
          ),
          Text(
            "Description",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: _formElementMargin,
          ),
          Text(
            poll.description,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }

  Widget createPollChart(Poll poll) {
    List<Widget> columnItems = [];
    SizedBox marginBox = SizedBox(
      height: _formControlMargin * 2,
    );

    for (Question question in poll.questions) {
      columnItems.add(marginBox);
      columnItems.add(QuestionResultItem(
        question: question,
      ));
    }

    return Container(
      margin: EdgeInsets.all(_formElementMargin),
      child: Column(
        children: columnItems,
      ),
    );
  }

  Widget createShareView(Poll poll) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text("Share"),
        ),
      ],
    );
  }
}
