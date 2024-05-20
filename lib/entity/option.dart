class Option {
  late String id;
  late String questionId;
  late String pollId;
  late bool editMode;
  late bool selected;
  late String text;

  Option(this.id, this.questionId, this.pollId, this.editMode, this.selected,
      this.text);

  Map<String, dynamic> toJSON() {
    return {"id": id, "questionId": questionId, "pollId": pollId, "text": text};
  }

  static Option fromJson(Map<String, dynamic> json) {
    return Option(
      json['_id'],
      json['question_id'],
      json['poll_id'],
      false,
      false,
      json['text'],
    );
  }
}
