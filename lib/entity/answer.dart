class Answer {
  final String answerId;
  final String questionId;
  final String pollId;
  final String answerBy;
  final String answer;

  Answer(
      {required this.answerId,
      required this.questionId,
      required this.pollId,
      required this.answerBy,
      required this.answer});

  Map<String, dynamic> toJSON() {
    return {
      "answerId": answerId,
      "questionId": questionId,
      "pollId": pollId,
      "answerBy": answerBy,
      "answer": answer
    };
  }

  static Answer fromJSON(Map<String, dynamic> answerResponse) {
    return Answer(
      answerId: answerResponse['_id'],
      questionId: answerResponse['question_id'],
      pollId: answerResponse['poll_id'],
      answer: answerResponse['answer'],
      answerBy: answerResponse['answer_by'],
    );
  }
}
