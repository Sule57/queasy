/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queasy/src.dart';

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
class EditQuizTextField extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  String validatorText;
  String controllerText;
  Question? question;

  EditQuizTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validatorText,
    required this.controllerText,
    this.question,
  }) : super(key: key);

  @override
  State<EditQuizTextField> createState() => _EditQuizTextFieldState();
}

class _EditQuizTextFieldState extends State<EditQuizTextField> {
  int MAX_INPUT_LENGTH = 35;

  get question => widget.question;
  get validatorText => widget.validatorText;
  get hintText => widget.hintText;
  get controllerText => widget.controllerText;
  get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: MediaQuery.of(context).size.width < 700
            ? const EdgeInsets.only(right: 2, bottom: 8)
            : const EdgeInsets.all(8.0),
        child: Container(
          height: 35,
          width: MediaQuery.of(context).size.width < 700
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width / 3,
          child: TextFormField(
            controller: controller
              ..text = controllerText,
            inputFormatters: [LengthLimitingTextInputFormatter(MAX_INPUT_LENGTH)],
            validator: (value) {
              // If field is null or full of empty spaces
              if (value == null || value.trim().isEmpty) {
                return validatorText;
              }
              return null;
            },
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
            // onFieldSubmitted: (value) {
            //   if (question != null) (value) => controller.text = value;
            // },
            // onSaved: (value) {
            //   if (question != null) (value) => controller.text = value;
            // },
            // onChanged: (value) {
            //   if (question != null) {
            //     question.text = value;
            //   }
            // },
          ),
        ),
      ),
    );
  }
}
