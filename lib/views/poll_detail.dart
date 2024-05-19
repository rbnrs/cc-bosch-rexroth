import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:poll_app/entity/poll.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/utils/app_service.dart';
import 'package:poll_app/utils/app_service_web.dart';
import 'package:poll_app/utils/app_status.dart';
import 'package:poll_app/utils/poll_service_handler.dart';
import 'package:poll_app/views/add_question_view.dart';
import 'package:poll_app/widgets/question_list_item.dart';
import 'package:poll_app/widgets/question_result_item.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PollDetailView extends StatefulWidget {
  final String pollId;

  const PollDetailView({super.key, required this.pollId});

  @override
  State<PollDetailView> createState() => _PollDetailViewState();
}

class _PollDetailViewState extends State<PollDetailView> {
  Poll poll = AppStatus.currentPoll;
  final double _formElementMargin = 15;
  final double _formControlMargin = 30;
  final double _itemBorderRadius = 10;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PollServiceHandler().onLoadPollById(widget.pollId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Poll poll = snapshot.data!;
          return Scaffold(
            appBar:
                GeneralFragments.createAppBar('Poll Overview', true, context),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: _formElementMargin,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      createPollHeader(poll),
                      const Spacer(),
                      createShareView(poll, context),
                      SizedBox(
                        width: _formControlMargin,
                      )
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: createPollChart(poll),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget createPollHeader(Poll poll) {
    return Container(
      margin: EdgeInsets.all(_formElementMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            poll.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(
            height: _formElementMargin / 2,
          ),
          Text(
            poll.id,
          ),
          SizedBox(
            height: _formElementMargin * 2,
          ),
          Text(
            "Description",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: _formElementMargin,
          ),
          Text(
            poll.description,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }

  Widget createPollChart(Poll poll) {
    List<Widget> columnItems = [];
    SizedBox marginBox = SizedBox(
      height: _formControlMargin * 2,
    );

    for (Question question in poll.questions) {
      columnItems.add(marginBox);
      columnItems.add(QuestionResultItem(
        question: question,
      ));
    }

    return Container(
      margin: EdgeInsets.all(_formElementMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: columnItems,
      ),
    );
  }

  Widget createShareView(Poll poll, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            openShareDialog();
          },
          icon: const Icon(Icons.share, color: Colors.grey),
        ),
      ],
    );
  }

  void openShareDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_itemBorderRadius)),
          surfaceTintColor: Colors.transparent,
          child: createShareDialogContent(),
        );
      },
    );
  }

  Widget createShareDialogContent() {
    String pollUri = Uri.base.toString().replaceFirst('pollDetail', '');

    final formKey = GlobalKey();

    QrCode qrCode = QrCode(1, QrErrorCorrectLevel.L);
    qrCode.addData(pollUri);

    return Container(
      padding: EdgeInsets.all(_formElementMargin),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                ),
              )
            ],
          ),
          Text(
            "Share your Poll",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: _formControlMargin,
          ),
          Text(
            "Link to poll",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          SizedBox(
            height: _formElementMargin,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: pollUri,
                  enabled: false,
                ),
              ),
              SizedBox(
                width: _formElementMargin,
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: pollUri));
                  ScaffoldMessenger.of(context)
                      .showSnackBar(GeneralFragments.createInfoSnackbar(
                    'URL copied!',
                    context,
                  ));
                },
                icon: const Icon(Icons.copy),
              )
            ],
          ),
          SizedBox(
            height: _formElementMargin * 2,
          ),
          Center(
              child: Column(
            children: [
              RepaintBoundary(
                key: formKey,
                child: QrImageView(
                  size: 150,
                  data: pollUri,
                ),
              ),
              SizedBox(
                height: _formElementMargin,
              ),
              TextButton(
                  onPressed: () async {
                    final RenderRepaintBoundary boundary =
                        formKey.currentContext!.findRenderObject()!
                            as RenderRepaintBoundary;

                    final image = await boundary.toImage();
                    ByteData? byteData =
                        await image.toByteData(format: ImageByteFormat.png);

                    if (byteData != null) {
                      Uint8List pngBytes = byteData.buffer.asUint8List();
                      if (kIsWeb) {
                        AppServiceWeb()
                            .downloadPicture(pngBytes, "${widget.pollId}.png");
                      } else {
                        AppService()
                            .downloadPicture(pngBytes, "${widget.pollId}.png");
                      }
                    }
                  },
                  child: const Text("Download QR Code"))
            ],
          )),
          SizedBox(
            height: _formElementMargin,
          ),
        ],
      ),
    );
  }
}
