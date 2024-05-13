import 'package:flutter/material.dart';
import 'package:poll_app/entity/question.dart';
import 'package:uuid/uuid.dart';

class QuestionOptionItem extends StatefulWidget {
  final String itemUuid = const Uuid().v1();

  final QuestionType optionType;
  final bool editMode;
  final Function(String, bool) onItemSelect;
  final Function(String, String) onTextChange;
  final String text;
  final bool isSelected;

  String getItemUuid() {
    return itemUuid;
  }

  QuestionOptionItem(
      {super.key,
      required this.optionType,
      required this.editMode,
      required this.text,
      required this.isSelected,
      required this.onItemSelect,
      required this.onTextChange});

  @override
  State<QuestionOptionItem> createState() => _QuestionOptionItemState();
}

class _QuestionOptionItemState extends State<QuestionOptionItem> {
  final double _itemBorderRadius = 10;
  final double _itemPadding = 10;
  final double _iconSizeButton = 20;

  final ButtonStyle _actionButtonStyle = ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(15),
  );

  bool _editMode = true;
  bool _checkBoxState = false;
  bool _radioState = false;
  String _optionText = "";

  @override
  void initState() {
    super.initState();
    _checkBoxState = widget.isSelected;
    _radioState = widget.isSelected;
    _optionText = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_itemPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_itemBorderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                widget.optionType == QuestionType.multiSelection
                    ? Checkbox(
                        value: _checkBoxState,
                        onChanged: (value) {
                          _checkBoxState = value!;
                          setState(() {});
                          widget.onItemSelect(widget.itemUuid, _checkBoxState);
                        },
                      )
                    : Checkbox(
                        value: _radioState,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                        onChanged: (value) {
                          _radioState = value!;
                          setState(() {});
                          widget.onItemSelect(widget.itemUuid, _checkBoxState);
                        }),
                SizedBox(
                  width: _itemPadding,
                ),
                Expanded(
                  child: _editMode
                      ? TextFormField(
                          maxLength: 50,
                          initialValue: _optionText,
                          onChanged: (value) {
                            _optionText = value;
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter Text...",
                            counterText: "",
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          _optionText,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                )
              ],
            ),
          ),
          SizedBox(
            width: _itemPadding,
          ),
          widget.editMode ? getActionButtonsForItem() : Container()
        ],
      ),
    );
  }

  Widget getActionButtonsForItem() {
    return !_editMode
        ? ElevatedButton(
            onPressed: () {
              _editMode = true;
              setState(() {});
              //TODO do something for edit
            },
            style: _actionButtonStyle,
            child: Icon(
              Icons.edit,
              size: _iconSizeButton,
            ),
          )
        : ElevatedButton(
            onPressed: () {
              _editMode = false;
              setState(() {});
              //TODO do something for save
            },
            style: _actionButtonStyle,
            child: Icon(
              Icons.save,
              size: _iconSizeButton,
            ),
          );
  }
}
