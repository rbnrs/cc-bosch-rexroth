import 'package:flutter/material.dart';
import 'package:poll_app/entity/poll.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/utils/poll_service_handler.dart';
import 'package:poll_app/widgets/poll_list_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Poll> polls = [];

  @override
  void initState() {
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
      body: FutureBuilder(
        future: PollServiceHandler().loadPolls(),
        builder: (context, snapshot) {
          if (ConnectionState.done == snapshot.connectionState) {
            if (snapshot.hasData) {
              polls = snapshot.data!;
            }
            return Center(
              child: polls.isNotEmpty
                  ? ListView.builder(
                      itemCount: polls.length,
                      itemExtent: 150,
                      itemBuilder: (context, index) {
                        return PollListItem(
                          poll: polls[index],
                        );
                      })
                  : const Center(
                      child: Text("No polls available!"),
                    ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
