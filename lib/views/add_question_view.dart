import 'package:flutter/material.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/utils/custom_styles.dart';
import 'package:poll_app/widgets/question_create_list.dart';

class AddQuestionView extends StatefulWidget {
  const AddQuestionView({super.key});

  @override
  State<AddQuestionView> createState() => _AddQuestionViewState();
}

class _AddQuestionViewState extends State<AddQuestionView> {
  final formKey = GlobalKey<FormState>();

  List<Option> singleSelectOptions = [];
  List<Option> multiSelectOptions = [];

  String question = "";

  QuestionType questionType = QuestionType.singleSelection;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: GeneralFragments.createAppBar("Add Question", true, context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!formKey.currentState!.validate()) return;

          List<Option> options = [];

          if (QuestionType.singleSelection == questionType) {
            options = singleSelectOptions;
          }

          if (QuestionType.multiSelection == questionType) {
            options = multiSelectOptions;
          }

          Question questionConfirm = Question(
            '',
            question,
            'EN', //TODO remove later with selected language
            questionType,
            options,
            [],
          );

          Navigator.of(context).pop([questionConfirm]);
        },
        icon: const Icon(Icons.check),
        label: const SizedBox(
          width: 100,
          child: Text(
            "Confirm",
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
              child: createQuestionForm(),
            )),
          )
        ],
      ),
    );
  }

  Widget createQuestionForm() {
    return Column(
      children: [
        createQuestionModeInput(),
        const SizedBox(
          height: CustomStyles.formControlMargin,
        ),
        createQuestionTitleInput(),
        const SizedBox(
          height: CustomStyles.formControlMargin,
        ),
        showQuestionOptionForm()
      ],
    );
  }

  Widget createQuestionTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(
          height: CustomStyles.formElementMargin,
        ),
        Form(
          key: formKey,
          child: TextFormField(
            validator: (value) {
              return value!.isEmpty ? 'Please enter a question' : null;
            },
            decoration:
                const InputDecoration(hintText: "Enter the question..."),
            onChanged: (val) {
              question = val;
            },
          ),
        )
      ],
    );
  }

  Widget createQuestionModeInput() {
    const double answerOptionMargin = 15;

    onPressSingleSelect() {
      questionType = QuestionType.singleSelection;
      setState(() {});
    }

    onPressMultiSelect() {
      questionType = QuestionType.multiSelection;
      setState(() {});
    }

    onPressTextInput() {
      questionType = QuestionType.textInput;
      setState(() {});
    }

    const Widget singleSelectContent = Text("Single Select");
    const Widget multiSelectContent = Text("Multi Select");
    const Widget textInputContent = Text("Text Input");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            questionType == QuestionType.singleSelection
                ? ElevatedButton(
                    onPressed: onPressSingleSelect,
                    child: singleSelectContent,
                  )
                : OutlinedButton(
                    onPressed: onPressSingleSelect, child: singleSelectContent),
            const SizedBox(
              width: answerOptionMargin,
            ),
            questionType == QuestionType.multiSelection
                ? ElevatedButton(
                    onPressed: onPressMultiSelect,
                    child: multiSelectContent,
                  )
                : OutlinedButton(
                    onPressed: onPressMultiSelect, child: multiSelectContent),
            const SizedBox(
              width: answerOptionMargin,
            ),
            questionType == QuestionType.textInput
                ? ElevatedButton(
                    onPressed: onPressTextInput,
                    child: textInputContent,
                  )
                : OutlinedButton(
                    onPressed: onPressTextInput, child: textInputContent)
          ],
        )
      ],
    );
  }

  Widget showQuestionOptionForm() {
    return getAnswerOptions();
  }

  Widget getAnswerOptions() {
    switch (questionType) {
      case QuestionType.singleSelection:
        return showSingleSelectionOption();
      case QuestionType.multiSelection:
        return showMultiSelectionOption();
      case QuestionType.textInput:
        return showTextInputOption();
    }
  }

  Widget showTextInputOption() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Enter your answer..."),
      maxLength: 250,
      maxLines: 3,
      enabled: false,
    );
  }

  Widget showSingleSelectionOption() {
    return QuestionCreateList(
      key: const Key('singleSelection'),
      optionType: QuestionType.singleSelection,
      creationMode: true,
      options: singleSelectOptions,
      onOptionItemSaved: (option) {
        singleSelectOptions.add(option);
      },
      onOptionRemoved: (option) {
        singleSelectOptions.remove(option);
      },
    );
  }

  Widget showMultiSelectionOption() {
    return QuestionCreateList(
      key: const Key('multiSelection'),
      optionType: QuestionType.multiSelection,
      creationMode: true,
      options: multiSelectOptions,
      onOptionItemSaved: (option) {
        multiSelectOptions.add(option);
      },
      onOptionRemoved: (option) {
        multiSelectOptions.remove(option);
      },
    );
  }
}
