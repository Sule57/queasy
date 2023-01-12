/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';

import '../category_questions_provider.dart';

/// This is the edit quiz text field.
///
/// It is the text field that is used in the [EditQuizView] to edit or add the questions.
///
/// The variable [controller] is the controller for the text field.
///
/// The variable [hintText] is the hint text that is shown in the text field.
///
/// The variable [validatorText] is the text that is shown if the text field is empty.
///
/// The variable [controllerText] is the text that is shown in the text field.
///
/// The variable [question] is the question that is about to be created, if the used
/// is using the text field to add a question.
///
/// The variable [MAX_INPUT_LENGTH] is the maximum length of the text field.
class QuestionsTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String validatorText;
  String controllerText;
  final Question? question;
  final bool isQuestion;
  final bool isLastField;
  final Function action;

  QuestionsTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validatorText,
    required this.controllerText,
    required this.isQuestion,
    required this.isLastField,
    required this.action,
    this.question,
  }) : super(key: key);

  @override
  State<QuestionsTextField> createState() => _QuestionsTextFieldState();
}

class _QuestionsTextFieldState extends State<QuestionsTextField> {
  final int MAX_INPUT_LENGTH = 50;

  get question => widget.question;
  get validatorText => widget.validatorText;
  get hintText => widget.hintText;
  get controllerText => widget.controllerText;
  get controller => widget.controller;
  get isQuestion => widget.isQuestion;
  get isLastField => widget.isLastField;
  get action => widget.action;

  // setter for controllerText
  void setControllerText(String value) {
    widget.controllerText = value;
  }

  @override
  Widget build(BuildContext context) {
    CategoryQuestionsProvider provider =
    Provider.of<CategoryQuestionsProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final _formKey = provider.formKeyAddEditQuestion;

    // set controllerText to 'a'
    if ((controller.text) != '') {
      setControllerText(controller.text);
    }
    return Expanded(
      child: Padding(
        padding: MediaQuery.of(context).size.width < 700
            ? const EdgeInsets.only(right: 2, bottom: 8)
            : const EdgeInsets.all(8.0),
        child: Container(
          height: isQuestion ? 45 : 35,
          width: MediaQuery.of(context).size.width < 700
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width / 3,
          child: TextFormField(
            onFieldSubmitted: (value) {
              // if i use _formKey.currentState!.validate() it throws an exception
              if (_formKey.currentState?.validate() ?? true) {
                // TODO: not validating correctly
                action();
                provider.clearTextFieldsAndButton();
                Navigator.pop(context);
              }
            },
            maxLines: isQuestion ? 2 : 1,
            controller: controller..text = controllerText,
            inputFormatters: [
              LengthLimitingTextInputFormatter(MAX_INPUT_LENGTH)
            ],
            validator: (value) {
              // If field is null or full of empty spaces
              if (value == null || value.trim().isEmpty) {
                return validatorText;
              }
              return null;
            },
            style: theme.textTheme.subtitle2,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 10, left: 20),
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
