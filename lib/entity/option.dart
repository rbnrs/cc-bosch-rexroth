class Option {
  late String id;
  late String questionId;
  late String pollId;
  late bool editMode;
  late bool selected;
  late String text;

  Option(this.id, this.questionId, this.pollId, this.editMode, this.selected,
      this.text);
}
