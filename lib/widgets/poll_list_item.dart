import 'package:flutter/material.dart';
import 'package:poll_app/entity/poll.dart';
import 'package:poll_app/utils/app_status.dart';
import 'package:poll_app/utils/custom_styles.dart';

class PollListItem extends StatefulWidget {
  final Poll poll;

  const PollListItem({super.key, required this.poll});

  @override
  State<PollListItem> createState() => _PollListItemState();
}

class _PollListItemState extends State<PollListItem> {
  @override
  Widget build(BuildContext context) {
    SizedBox sizedBox = const SizedBox(
      height: CustomStyles.formElementMargin,
    );

    final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(15),
    );

    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(CustomStyles.formElementMargin),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.poll.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      sizedBox,
                      Text(
                        widget.poll.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      sizedBox,
                      sizedBox,
                      Text(
                        //TODO
                        "Votes: 0",
                        style: Theme.of(context).textTheme.labelLarge,
                      )
                    ],
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: actionButtonStyle,
                          child: const Icon(Icons.edit),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            AppStatus.currentPoll = widget.poll;
                            String routeName = Uri(
                              path: '/pollDetail',
                              queryParameters: {
                                'pollId': widget.poll.id,
                              },
                            ).toString();

                            Navigator.of(context).pushNamed(routeName);
                          },
                          style: actionButtonStyle,
                          child: const Icon(Icons.bar_chart_outlined),
                        ),
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
