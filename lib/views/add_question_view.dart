import 'package:flutter/material.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/widgets/question_option_item.dart';
import 'package:uuid/uuid.dart';

class AddQuestionView extends StatefulWidget {
  const AddQuestionView({super.key});

  @override
  State<AddQuestionView> createState() => _AddQuestionViewState();
}

class _AddQuestionViewState extends State<AddQuestionView> {
  final double _formElementMargin = 15;
  final double _formControlMargin = 30;
  final double _buttonHeight = 50;

  final String _groupId = const Uuid().v1();

  QuestionType questionType = QuestionType.singleSelection;

  List<QuestionOptionItem> singleSelectionItems = [];
  List<QuestionOptionItem> multiSelectionItems = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.check),
        label: const Text('Confirm'),
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
        SizedBox(
          height: _formControlMargin,
        ),
        createQuestionTitleInput(),
        SizedBox(
          height: _formControlMargin,
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
        SizedBox(
          height: _formElementMargin,
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: "Enter the question..."),
          onChanged: (val) {},
        ),
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
    List<Widget> columnList = [];

    for (QuestionOptionItem questItem in singleSelectionItems) {
      columnList.add(questItem);
      columnList.add(SizedBox(
        height: _formElementMargin,
      ));
    }

    columnList.add(Row(
      children: [
        Expanded(
            child: SizedBox(
          height: _buttonHeight,
          child: TextButton(
            onPressed: () {
              //TODO add parameter + validation check
              singleSelectionItems.add(
                QuestionOptionItem(
                  optionType: QuestionType.singleSelection,
                  editMode: true,
                  text: '',
                  isSelected: false,
                  onTextChange: (val, uiod) {},
                  onItemSelect: (itemUuid, selected) {
                    //TODO remove test
                    uncheckItemsExcept(itemUuid);
                  },
                ),
              );
              setState(() {});
            },
            child: const Text("Add Option"),
          ),
        ))
      ],
    ));

    return Column(
      children: columnList,
    );
  }

  Widget showMultiSelectionOption() {
    List<Widget> columnList = [];

    for (QuestionOptionItem questItem in singleSelectionItems) {
      columnList.add(questItem);
      columnList.add(SizedBox(
        height: _formElementMargin,
      ));
    }
    columnList.add(Row(
      children: [
        Expanded(
            child: SizedBox(
          height: _buttonHeight,
          child: TextButton(
            onPressed: () {
              //TODO add parameter + validation check
              singleSelectionItems.add(QuestionOptionItem(
                optionType: QuestionType.multiSelection,
                text: '',
                isSelected: false,
                editMode: true,
                onTextChange: (val, uiod) {},
                onItemSelect: (itemUuid, selected) {
                  //TODO remove test
                  uncheckItemsExcept(itemUuid);
                },
              ));
              setState(() {});
            },
            child: const Text("Add Option"),
          ),
        ))
      ],
    ));

    return Column(
      children: columnList,
    );
  }

  void uncheckItemsExcept(String itemUuid) {
    for (QuestionOptionItem questItem in singleSelectionItems) {
      if (questItem.getItemUuid() != itemUuid) {
        int index = singleSelectionItems.indexOf(questItem);

        QuestionOptionItem questItemBuffer = QuestionOptionItem(
          optionType: questItem.optionType,
          editMode: questItem.editMode,
          text: '',
          isSelected: false,
          onItemSelect: (itemUuid, selected) {
            //TODO remove test
            uncheckItemsExcept(itemUuid);
          },
          onTextChange: (val, selected) {},
        );

        singleSelectionItems.removeAt(index);
        singleSelectionItems.insert(index, questItemBuffer);
      }
    }

    setState(() {});
  }
}
