import 'package:poll_app/entity/question.dart';

import 'option.dart';

class Poll {
  late String _id;
  late String _name;
  late String _description;
  late DateTime _timestamp;
  late List<Question> options;
}