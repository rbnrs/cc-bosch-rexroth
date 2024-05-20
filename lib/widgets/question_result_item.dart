import 'package:flutter/material.dart';
import 'package:poll_app/entity/answer.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/utils/custom_styles.dart';

class QuestionResultItem extends StatelessWidget {
  final Question question;
  final List<Answer> answers;
  const QuestionResultItem(
      {super.key, required this.question, required this.answers});

  @override
  Widget build(BuildContext context) {
    List<Widget> columnListItem = [];
    SizedBox marginBox = const SizedBox(
      height: CustomStyles.formElementMargin,
    );

    columnListItem.add(createQuestionItem(context));
    columnListItem.add(marginBox);

    for (Option option in question.options) {
      columnListItem.add(createOptionResultItem(context, option, answers));
      columnListItem.add(marginBox);
    }

    return Column(
      children: columnListItem,
    );
  }

  Widget createQuestionItem(BuildContext context) {
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

    double mediaWidth = MediaQuery.of(context).size.width * 0.9;

    return Container(
      padding: const EdgeInsets.all(CustomStyles.itemPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CustomStyles.itemBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(option.text),
          const SizedBox(
            height: CustomStyles.formElementMargin,
          ),
          Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  minWidth: 0,
                ),
                height: CustomStyles.optionItemHeight,
                width: mediaWidth * optionAnswerQuote,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius:
                      BorderRadius.circular(CustomStyles.itemBorderRadius),
                ),
              ),
              const Spacer(),
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
