import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queasy/src.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  String validatorText;
  String controllerText;
  Question? question;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validatorText,
    required this.controllerText,
    this.question,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  int MAX_INPUT_LENGTH = 35;

  get question => widget.question;
  get validatorText => widget.validatorText;
  get hintText => widget.hintText;
  get controllerText => widget.controllerText;
  get controller => widget.controller;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width < 700
          ? const EdgeInsets.only(right: 2, bottom: 8)
          : const EdgeInsets.all(8.0),
      child: Expanded(
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
          ),
        ),
      ),
    );
  }
}
