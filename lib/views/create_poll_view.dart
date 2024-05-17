import 'package:flutter/material.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/utils/poll_service_handler.dart';
import 'package:poll_app/widgets/question_list_item.dart';

class CreatePollView extends StatefulWidget {
  const CreatePollView({super.key});

  @override
  State<CreatePollView> createState() => _CreatePollViewState();
}

class _CreatePollViewState extends State<CreatePollView> {
  final formKey = GlobalKey<FormState>();
  final formKeyDesc = GlobalKey<FormState>();
  final double _formElementMargin = 15;
  final double _formControlMargin = 30;

  String pollName = "";
  String pollDescription = "";
  List<Question> questions = [];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: GeneralFragments.createAppBar("Create Poll", true, context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!formKey.currentState!.validate() ||
              !formKey.currentState!.validate()) {
            return;
          }
          bool successfull = await onSavePoll();

          onShowMessage(successfull);
        },
        icon: const Icon(Icons.save),
        label: const SizedBox(
          width: 100,
          child: Text(
            "Save",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
                child: Container(
              margin: const EdgeInsets.all(15),
              constraints: const BoxConstraints(minWidth: 500),
              width: screenWidth > 500 ? screenWidth * .3 : 500,
              child: createPollForm(),
            )),
          )
        ],
      ),
    );
  }

  Widget createPollForm() {
    double buttonHeight = 50;

    List<Widget> columnItems = [];
    SizedBox marginBox = SizedBox(
      height: _formControlMargin,
    );

    columnItems.add(createPollNameInput());
    columnItems.add(marginBox);
    columnItems.add(createPollDescription());
    columnItems.add(marginBox);

    columnItems.add(Row(
      children: [
        Expanded(
            child: SizedBox(
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/addQuestion').then((value) {
                Object object = List.of(value as List).last;

                if (object is Question) {
                  questions.add(object);
                }
                setState(() {});
              });
            },
            child: const Text("Add Question"),
          ),
        )),
      ],
    ));

    for (Question question in questions) {
      columnItems.add(marginBox);
      columnItems.add(
        QuestionListItem(
          question: question,
          onQuestionRemoved: (question) {
            questions.remove(question);
            setState(() {});
          },
        ),
      );
    }

    return Column(
      children: columnItems,
    );
  }

  Widget createPollNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(
          height: _formElementMargin,
        ),
        Form(
          key: formKey,
          child: TextFormField(
            validator: (value) {
              return value!.isEmpty ? 'Please enter a name' : null;
            },
            decoration: const InputDecoration(hintText: "Enter poll name..."),
            onChanged: (val) {
              pollName = val;
            },
          ),
        )
      ],
    );
  }

  Widget createPollDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(
          height: _formElementMargin,
        ),
        Form(
          key: formKeyDesc,
          child: TextFormField(
            validator: (value) {
              return value!.isEmpty ? 'Please enter a description' : null;
            },
            decoration:
                const InputDecoration(hintText: "Enter poll description..."),
            maxLines: 5,
            maxLength: 250,
            onChanged: (val) {
              pollDescription = val;
            },
          ),
        )
      ],
    );
  }

  Future<bool> onSavePoll() async {
    return await PollServiceHandler()
        .onSavePoll(pollName, pollDescription, questions);
  }

  void onShowMessage(bool successfull) {
    if (successfull) {
      ScaffoldMessenger.of(context).showSnackBar(
          GeneralFragments.createInfoSnackbar(
              'Successfully created!', context));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          GeneralFragments.createErrorSnackbar('Can\'t create poll!', context));
    }
  }
}
