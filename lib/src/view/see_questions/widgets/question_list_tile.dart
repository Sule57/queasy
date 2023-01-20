/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';
import '../../widgets/rounded_button.dart';

/// The widget [QuestionListTile] is used to show a question and its answers.
///
/// The [RoundedButton] widgets are used to edit or delete the question.
class QuestionListTile extends StatefulWidget {
  /// Used to show or hide the container that contains the answers.
  final bool isContainerVisible;

  /// Question that is going to be shown.
  final Question question;

  /// Constructor for the [QuestionListTile].
  QuestionListTile({
    Key? key,
    required this.isContainerVisible,
    required this.question,
  }) : super(key: key);

  /// Creates the state for this widget.
  @override
  State<QuestionListTile> createState() => _QuestionListTileState();
}

/// State for the [QuestionListTile].
class _QuestionListTileState extends State<QuestionListTile> {
  get isContainerVisible => widget.isContainerVisible;

  get question => widget.question;

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return ListTile(
      title: Container(
        height: isContainerVisible ? 180 : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (question.answers[0].isCorrect)
              CorrectAnswerContainer(text: question.answers[0].text)
            else
              Text(question.answers[0].text, style: TextStyle(fontSize: 15)),
            if (question.answers[1].isCorrect)
              CorrectAnswerContainer(text: question.answers[1].text)
            else
              Text(question.answers[1].text, style: TextStyle(fontSize: 15)),
            if (question.answers[2].isCorrect)
              CorrectAnswerContainer(text: question.answers[2].text)
            else
              Text(question.answers[2].text, style: TextStyle(fontSize: 15)),
            if (question.answers[3].isCorrect)
              CorrectAnswerContainer(text: question.answers[3].text)
            else
              Text(question.answers[3].text, style: TextStyle(fontSize: 15)),
            if (isMobile)
              MobileButtons(question: question)
            else
              DesktopButtons(question: question),
          ],
        ),
      ),
    );
  }
}

/// This widget is used to show the correct answer of a question in green.
class CorrectAnswerContainer extends StatelessWidget {
  /// Text of the correct answer.
  final String text;

  CorrectAnswerContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context).currentTheme!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.tertiary,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(fontSize: 15)),
      ),
    );
  }
}

/// This widget is used to show the buttons to edit or delete a question on a
/// mobile device. The buttons are displayed on top of each other.
class MobileButtons extends StatelessWidget {
  /// Question that is going to be edited or deleted.
  final Question question;

  MobileButtons({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// The provider of the class
    CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context, listen: true);
    var theme = Provider.of<ThemeProvider>(context).currentTheme!;

    return Column(
      children: [
        RoundedButton(
          buttonName: 'Edit Question',
          width: 200,
          height: 35,
          fontSize: 13,
          borderColor: theme.colorScheme.tertiary,
          backgroundColor: Colors.transparent,
          textColor: theme.colorScheme.tertiary,
          fontWeight: FontWeight.normal,
          onPressed: () => controller.editQuestion(context, question),
        ),
        const SizedBox(height: 2),
        RoundedButton(
          buttonName: 'Delete Question',
          width: 200,
          height: 35,
          fontSize: 13,
          borderColor: theme.colorScheme.secondary,
          backgroundColor: Colors.transparent,
          textColor: theme.colorScheme.secondary,
          fontWeight: FontWeight.normal,
          onPressed: () => controller.deleteQuestion(context, question),
        ),
      ],
    );
  }
}

/// This widget is used to show the buttons to edit or delete a question on a
/// desktop device. The buttons are displayed next to each each other.
class DesktopButtons extends StatelessWidget {
  /// Question that is going to be edited or deleted.
  final Question question;

  DesktopButtons({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// The provider of the class
    CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context, listen: true);
    var theme = Provider.of<ThemeProvider>(context).currentTheme!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RoundedButton(
          buttonName: 'Delete Question',
          width: 200,
          height: 35,
          fontSize: 13,
          borderColor: theme.colorScheme.secondary,
          backgroundColor: theme.colorScheme.background,
          textColor: theme.colorScheme.secondary,
          fontWeight: FontWeight.normal,
          onPressed: () => controller.deleteQuestion(context, question),
        ),
        RoundedButton(
          buttonName: 'Edit Question',
          width: 200,
          height: 35,
          fontSize: 13,
          borderColor: theme.colorScheme.tertiary,
          backgroundColor: theme.colorScheme.background,
          textColor: theme.colorScheme.tertiary,
          fontWeight: FontWeight.normal,
          onPressed: () => controller.editQuestion(context, question),
        ),
      ],
    );
  }
}
