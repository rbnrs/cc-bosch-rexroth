import 'package:flutter/material.dart';
import 'package:poll_app/entity/answer.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/question.dart';

class QuestionResultItem extends StatelessWidget {
  final Question question;

  const QuestionResultItem({super.key, required this.question});

  final double _itemBorderRadius = 10;
  final double _itemPadding = 10;
  final double _formElementMargin = 10;
  final double _optionItemHeight = 30;

  @override
  Widget build(BuildContext context) {
    List<Widget> columnListItem = [];
    SizedBox marginBox = SizedBox(
      height: _formElementMargin,
    );

    columnListItem.add(createQuestionItem(context));
    columnListItem.add(marginBox);

    for (Option option in question.options) {
      columnListItem
          .add(createOptionResultItem(context, option, question.answers));
      columnListItem.add(marginBox);
    }

    return Column(
      children: columnListItem,
    );
  }

  Widget createQuestionItem(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_itemPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(_itemBorderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              question.text,
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

  Widget createOptionResultItem(
      BuildContext context, Option option, List<Answer> answers) {
    int countOptionAnswer =
        answers.where((element) => element.answer == option.id).length;

    double optionAnswerQuote =
        answers.isEmpty ? 0 : countOptionAnswer / answers.length;

    return Container(
      padding: EdgeInsets.all(_itemPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_itemBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(option.text),
          SizedBox(
            height: _formElementMargin,
          ),
          Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  minWidth: 0,
                ),
                height: _optionItemHeight,
                width: MediaQuery.of(context).size.width * optionAnswerQuote,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(_itemBorderRadius),
                ),
              ),
              Spacer(),
              Text(
                countOptionAnswer.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
        ],
      ),
    );
  }
}
