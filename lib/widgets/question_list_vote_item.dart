import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';

class QuestionListVoteItem extends StatefulWidget {
  final Question question;
  final Function(Question, String) onVote;

  const QuestionListVoteItem(
      {super.key, required this.question, required this.onVote});

  @override
  State<QuestionListVoteItem> createState() => _QuestionListVoteItemState();
}

class _QuestionListVoteItemState extends State<QuestionListVoteItem> {
  final double _formElementMargin = 15;
  final double _buttonHeight = 50;
  final double _itemBorderRadius = 10;
  final double _itemPadding = 10;
  final double _iconSizeButton = 20;

  List<Option> options = [];

  @override
  initState() {
    super.initState();
    options.addAll(widget.question.options);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnList = [];
    List<Option> options = [];
    SizedBox marginBox = SizedBox(
      height: _formElementMargin,
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
      padding: EdgeInsets.all(_itemPadding),
      margin:
          EdgeInsets.only(left: _formElementMargin, right: _formElementMargin),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(_itemBorderRadius),
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
      padding: EdgeInsets.all(_itemPadding),
      margin:
          EdgeInsets.only(left: _formElementMargin, right: _formElementMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_itemBorderRadius),
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
                SizedBox(
                  width: _itemPadding,
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
          SizedBox(
            width: _itemPadding,
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
