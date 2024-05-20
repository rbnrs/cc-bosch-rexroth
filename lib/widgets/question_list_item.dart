import 'package:flutter/material.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/utils/custom_styles.dart';

class QuestionListItem extends StatefulWidget {
  final Question question;
  final Function(Question) onQuestionRemoved;

  const QuestionListItem(
      {super.key, required this.question, required this.onQuestionRemoved});

  @override
  State<QuestionListItem> createState() => _QuestionListItemState();
}

class _QuestionListItemState extends State<QuestionListItem> {
  final formKey = GlobalKey<FormState>();

  List<Option> options = [];

  @override
  initState() {
    options.addAll(widget.question.options);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnListItem = [];
    SizedBox marginBox = const SizedBox(
      height: CustomStyles.formElementMargin,
    );

    columnListItem.add(createQuestionItem());
    columnListItem.add(marginBox);

    for (Option option in options) {
      columnListItem.add(createOptionItem(option));
      columnListItem.add(marginBox);
    }

    return Column(
      children: columnListItem,
    );
  }

  Widget createQuestionItem() {
    return Container(
      padding: const EdgeInsets.all(CustomStyles.itemPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(CustomStyles.itemBorderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.question.text,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
          SizedBox(
            width: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onQuestionRemoved(widget.question);
              },
              style: const ButtonStyle(
                  alignment: Alignment.center,
                  elevation: MaterialStatePropertyAll(0),
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.transparent)),
              child: const Icon(Icons.delete),
            ),
          )
        ],
      ),
    );
  }

  Widget createOptionItem(Option option) {
    return Container(
      padding: const EdgeInsets.all(CustomStyles.itemPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CustomStyles.itemBorderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                widget.question.type == QuestionType.multiSelection
                    ? Checkbox(
                        value: option.selected,
                        onChanged: (value) {
                          if (option.editMode) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                GeneralFragments.createInfoSnackbar(
                                    'Not possible in edit mode', context));
                            return;
                          }

                          int optionIndex;

                          if (widget.question.type ==
                              QuestionType.multiSelection) {
                            optionIndex = options.indexOf(option);
                            options[optionIndex].selected = value!;
                          }

                          setState(() {});
                        },
                      )
                    : Checkbox(
                        value: option.selected,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                        onChanged: (value) {
                          if (option.editMode) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                GeneralFragments.createInfoSnackbar(
                                    'Not possible in edit mode', context));
                            return;
                          }
                          if (value == true) uncheckAllOptions();

                          int optionIndex;

                          if (widget.question.type ==
                              QuestionType.singleSelection) {
                            optionIndex = options.indexOf(option);
                            options[optionIndex].selected = value!;
                          }

                          setState(() {});
                        }),
                const SizedBox(
                  width: CustomStyles.itemPadding,
                ),
                Expanded(
                  child: option.editMode
                      ? Form(
                          key: formKey,
                          child: TextFormField(
                            maxLength: 50,
                            initialValue: option.text,
                            onChanged: (value) {
                              int optionIndex;

                              if (widget.question.type ==
                                  QuestionType.singleSelection) {
                                optionIndex = options.indexOf(option);
                                options[optionIndex].text = value;
                              }

                              if (widget.question.type ==
                                  QuestionType.multiSelection) {
                                optionIndex = options.indexOf(option);
                                options[optionIndex].text = value;
                              }

                              setState(() {});
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter Text...",
                              counterText: "",
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      : Text(
                          option.text,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: CustomStyles.itemPadding,
          ),
        ],
      ),
    );
  }

  void uncheckAllOptions() {
    for (Option optionLoop in widget.question.options) {
      int index = options.indexOf(optionLoop);
      options[index].selected = false;
    }
  }
}
