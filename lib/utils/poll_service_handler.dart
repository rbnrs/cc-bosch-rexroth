import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poll_app/entity/answer.dart';
import 'package:poll_app/entity/poll.dart';
import 'package:poll_app/entity/question.dart';

class PollServiceHandler {
  static const String _serviceURL = "http://localhost:8000";

  Future<bool> onSavePoll(
      String pollName, String pollDescr, List<Question> questions) async {
    try {
      Poll poll = Poll(
          id: '',
          description: pollDescr,
          name: pollName,
          questions: questions,
          timestamp: DateTime.now());

      http.Response response = await http.post(Uri.parse("$_serviceURL/poll"),
          body: jsonEncode(poll.toJSON()));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Poll>> loadPolls() async {
    List<Poll> polls = [];

    http.Response response = await http.get(Uri.parse("$_serviceURL/poll"));
    List responseContent = jsonDecode(response.body);

    for (Map<String, dynamic> pollResponse in responseContent) {
      Poll poll = Poll.fromJSON(pollResponse);
      polls.add(poll);
    }

    return polls;
  }

  Future<Poll> onLoadPollById(String id) async {
    http.Response response = await http.get(Uri.parse('$_serviceURL/poll/$id'));

    Map<String, dynamic> responseContent = jsonDecode(response.body);
    Poll poll = Poll.fromJSON(responseContent);

    return poll;
  }

  Future<bool> onVoteForPoll(Answer answer) async {
    http.Response responseAnswer = await http.post(
      Uri.parse("$_serviceURL/answer"),
      body: jsonEncode(answer.toJSON()),
    );

    if (responseAnswer.statusCode == 201 || responseAnswer.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> checkForVote(String pollId) async {
    http.Response response =
        await http.get(Uri.parse('https://api.ipify.org/?format=json'));

    Map<String, dynamic> responseContent = jsonDecode(response.body);
    String userIp = responseContent['ip'];

    http.Response responseCheck =
        await http.get(Uri.parse("$_serviceURL/checkAnswer/$userIp/$pollId"));

    Map<String, dynamic> responseContentCheck = jsonDecode(responseCheck.body);

    return responseContentCheck['hasVoted'];
  }

  Future<List<Answer>> getAnswersForPoll(String pollId) async {
    List<Answer> answers = [];

    http.Response responseAnswer =
        await http.get(Uri.parse("$_serviceURL/answer/$pollId"));

    List responseContent = jsonDecode(responseAnswer.body);

    for (Map<String, dynamic> answerResponse in responseContent) {
      Answer answer = Answer.fromJSON(answerResponse);
      answers.add(answer);
    }

    return answers;
  }
}
