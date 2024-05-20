import 'package:flutter/material.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/utils/custom_styles.dart';

class QuestionListVoteItem extends StatefulWidget {
  final Question question;
  final Function(Question, String) onVote;

  const QuestionListVoteItem(
      {super.key, required this.question, required this.onVote});

  @override
  State<QuestionListVoteItem> createState() => _QuestionListVoteItemState();
}

class _QuestionListVoteItemState extends State<QuestionListVoteItem> {
  List<Option> options = [];

  @override
  initState() {
    super.initState();
    options.addAll(widget.question.options);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnList = [];
    SizedBox marginBox = const SizedBox(
      height: CustomStyles.formElementMargin,
    );

    columnList.add(createQuestionItem());
    columnList.add(marginBox);

    for (Option option in widget.question.options) {
      columnList.add(createQuestionOptionItem(option));
      columnList.add(marginBox);
    }
    return Column(
      children: columnList,
    );
  }

  Widget createQuestionItem() {
    return Container(
      padding: const EdgeInsets.all(CustomStyles.itemPadding),
      margin: const EdgeInsets.only(
          left: CustomStyles.formElementMargin,
          right: CustomStyles.formElementMargin),
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
        ],
      ),
    );
  }

  Widget createQuestionOptionItem(Option option) {
    return Container(
      padding: const EdgeInsets.all(CustomStyles.itemPadding),
      margin: const EdgeInsets.only(
          left: CustomStyles.formElementMargin,
          right: CustomStyles.formElementMargin),
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
                          int optionIndex;

                          if (widget.question.type ==
                              QuestionType.multiSelection) {
                            optionIndex = options.indexOf(option);
                            options[optionIndex].selected = value!;
                          }

                          widget.onVote(widget.question, option.id);
                          setState(() {});
                        },
                      )
                    : Checkbox(
                        value: option.selected,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                        onChanged: (value) {
                          if (value == true) uncheckAllOptions();

                          int optionIndex;

                          if (widget.question.type ==
                              QuestionType.singleSelection) {
                            optionIndex = options.indexOf(option);
                            options[optionIndex].selected = value!;
                          }

                          widget.onVote(widget.question, option.id);

                          setState(() {});
                        }),
                const SizedBox(
                  width: CustomStyles.itemPadding,
                ),
                Expanded(
                  child: Text(
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
