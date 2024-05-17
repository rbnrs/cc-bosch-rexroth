import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/poll.dart';

class AppStatus {
  static List<Option> singleSelectOptions = [];
  static List<Option> multiSelectOptions = [];
  static Poll currentPoll = Poll.createEmptyPoll();
}
