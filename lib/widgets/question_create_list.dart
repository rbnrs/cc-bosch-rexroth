import 'package:flutter/material.dart';
import 'package:poll_app/entity/option.dart';
import 'package:poll_app/entity/question.dart';
import 'package:poll_app/fragments/general_fragments.dart';
import 'package:poll_app/utils/custom_styles.dart';
import 'package:uuid/uuid.dart';

class QuestionCreateList extends StatefulWidget {
  final QuestionType optionType;
  final bool creationMode;
  final List<Option> options;
  final Function(Option) onOptionItemSaved;
  final Function(Option) onOptionRemoved;

  const QuestionCreateList(
      {super.key,
      required this.optionType,
      required this.creationMode,
      required this.options,
      required this.onOptionItemSaved,
      required this.onOptionRemoved});

  @override
  State<QuestionCreateList> createState() => _QuestionCreateListState();
}

class _QuestionCreateListState extends State<QuestionCreateList> {
  final formKey = GlobalKey<FormState>();

  final ButtonStyle _actionButtonStyle = ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(15),
  );

  List<Option> singleSelectOptions = [];
  List<Option> multiSelectOptions = [];

  @override
  void initState() {
    if (widget.optionType == QuestionType.singleSelection) {
      singleSelectOptions = [];
      singleSelectOptions.addAll(widget.options);
    }

    if (widget.optionType == QuestionType.multiSelection) {
      multiSelectOptions = [];
      multiSelectOptions.addAll(widget.options);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnList = [];
    List<Option> options = [];

    if (widget.optionType == QuestionType.singleSelection) {
      options = singleSelectOptions;
    }

    if (widget.optionType == QuestionType.multiSelection) {
      options = multiSelectOptions;
    }

    for (Option option in options) {
      columnList.add(createQuestionOptionItem(option));
      columnList.add(const SizedBox(
        height: CustomStyles.formElementMargin,
      ));
    }

    columnList.add(Row(
      children: [
        Expanded(
            child: SizedBox(
          height: CustomStyles.buttonHeight,
          child: TextButton(
            onPressed: () {
              if (widget.optionType == QuestionType.singleSelection) {
                try {
                  if (singleSelectOptions.isNotEmpty) {
                    singleSelectOptions
                        .firstWhere((element) => element.editMode == false);
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      GeneralFragments.createInfoSnackbar(
                          'Please save option entry, before adding a new one',
                          context));
                  return;
                }
              }

              if (widget.optionType == QuestionType.multiSelection) {
                try {
                  if (multiSelectOptions.isNotEmpty) {
                    multiSelectOptions
                        .firstWhere((element) => element.editMode == false);
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      GeneralFragments.createInfoSnackbar(
                          'Please save option entry, before adding a new one',
                          context));
                  return;
                }
              }

              options.add(Option(const Uuid().v1(), '', '', true, false, ''));
              setState(() {});
            },
            child: const Text("Add Option"),
          ),
        ))
      ],
    ));

    return Column(
      children: columnList,
    );
  }

  Widget createQuestionOptionItem(Option option) {
    int optionIndex;

    if (widget.optionType == QuestionType.singleSelection) {
      optionIndex = singleSelectOptions.indexOf(option);
    }

    if (widget.optionType == QuestionType.multiSelection) {
      optionIndex = multiSelectOptions.indexOf(option);
    }

    return Container(
      padding: const EdgeInsets.all(CustomStyles.itemPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CustomStyles.itemBorderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                widget.optionType == QuestionType.multiSelection
                    ? Checkbox(
                        value: option.selected,
                        onChanged: (value) {
                          if (option.editMode) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                GeneralFragments.createInfoSnackbar(
                                    'Not possible in edit mode', context));
                            return;
                          }
                          if (widget.optionType ==
                              QuestionType.singleSelection) {
                            optionIndex = singleSelectOptions.indexOf(option);
                            singleSelectOptions[optionIndex].selected = value!;
                          }

                          if (widget.optionType ==
                              QuestionType.multiSelection) {
                            optionIndex = multiSelectOptions.indexOf(option);
                            multiSelectOptions[optionIndex].selected = value!;
                          }

                          setState(() {});
                          // widget.onItemSelect(widget.itemUuid, _checkBoxState);
                        },
                      )
                    : Checkbox(
                        value: option.selected,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                        onChanged: (value) {
                          if (option.editMode) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                GeneralFragments.createInfoSnackbar(
                                    'Not possible in edit mode', context));
                            return;
                          }
                          if (value == true) uncheckAllOptions();

                          if (widget.optionType ==
                              QuestionType.singleSelection) {
                            optionIndex = singleSelectOptions.indexOf(option);
                            singleSelectOptions[optionIndex].selected = value!;
                          }

                          if (widget.optionType ==
                              QuestionType.multiSelection) {
                            optionIndex = multiSelectOptions.indexOf(option);
                            multiSelectOptions[optionIndex].selected = value!;
                          }

                          setState(() {});
                          // widget.onItemSelect(widget.itemUuid, _checkBoxState);
                        }),
                const SizedBox(
                  width: CustomStyles.itemPadding,
                ),
                Expanded(
                  child: option.editMode
                      ? Form(
                          key: formKey,
                          child: TextFormField(
                            maxLength: 50,
                            initialValue: option.text,
                            onChanged: (value) {
                              if (widget.optionType ==
                                  QuestionType.singleSelection) {
                                optionIndex =
                                    singleSelectOptions.indexOf(option);
                                singleSelectOptions[optionIndex].text = value;
                              }

                              if (widget.optionType ==
                                  QuestionType.multiSelection) {
                                optionIndex =
                                    multiSelectOptions.indexOf(option);
                                multiSelectOptions[optionIndex].text = value;
                              }

                              setState(() {});
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter Text...",
                              counterText: "",
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      : Text(
                          option.text,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: CustomStyles.itemPadding,
          ),
          widget.creationMode ? getActionButtonsForItem(option) : Container()
        ],
      ),
    );
  }

  Widget getActionButtonsForItem(Option option) {
    ButtonStyle actionButtonRemoveStyle = ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(15),
      backgroundColor: Theme.of(context).colorScheme.error,
    );

    return Row(
      children: [
        !option.editMode
            ? ElevatedButton(
                onPressed: () {
                  int optionIndex;

                  if (widget.optionType == QuestionType.singleSelection) {
                    optionIndex = singleSelectOptions.indexOf(option);
                    singleSelectOptions[optionIndex].editMode = true;
                  }

                  if (widget.optionType == QuestionType.multiSelection) {
                    optionIndex = multiSelectOptions.indexOf(option);
                    multiSelectOptions[optionIndex].editMode = true;
                  }

                  setState(() {});
                },
                style: _actionButtonStyle,
                child: const Icon(
                  Icons.edit,
                  size: CustomStyles.iconSizeButton,
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  int optionIndex;

                  if (widget.optionType == QuestionType.singleSelection) {
                    optionIndex = singleSelectOptions.indexOf(option);
                    singleSelectOptions[optionIndex].editMode = false;
                  }

                  if (widget.optionType == QuestionType.multiSelection) {
                    optionIndex = multiSelectOptions.indexOf(option);
                    multiSelectOptions[optionIndex].editMode = false;
                  }

                  if (!formKey.currentState!.validate()) return;

                  setState(() {});
                  widget.onOptionItemSaved(option);
                },
                style: _actionButtonStyle,
                child: const Icon(
                  Icons.save,
                  size: CustomStyles.iconSizeButton,
                ),
              ),
        ElevatedButton(
          onPressed: () {
            if (widget.optionType == QuestionType.singleSelection) {
              singleSelectOptions.remove(option);
            }

            if (widget.optionType == QuestionType.multiSelection) {
              multiSelectOptions.remove(option);
            }

            setState(() {});
            widget.onOptionItemSaved(option);
          },
          style: actionButtonRemoveStyle,
          child: const Icon(
            Icons.delete,
            size: CustomStyles.iconSizeButton,
          ),
        ),
      ],
    );
  }

  void uncheckAllOptions() {
    for (Option optionLoop in multiSelectOptions) {
      int index = multiSelectOptions.indexOf(optionLoop);
      multiSelectOptions[index].selected = false;
    }
  }
}
