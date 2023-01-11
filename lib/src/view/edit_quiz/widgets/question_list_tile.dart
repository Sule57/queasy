/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';
import '../../widgets/rounded-button.dart';
import '../edit_quiz_provider.dart';

/// The widget [QuestionListTile] is used to show a question and its answers.
///
/// The variable [question] is the question that is going to be shown.
///
/// The variable [isContainerVisible] is used to show or hide the container that
/// contains the answers.
///
/// The [RoundedButton] widgets are used to edit or delete the question.
class QuestionListTile extends StatefulWidget {
  /// [isContainerVisible] determines the size of the container
  final bool isContainerVisible;
  final Question question;

  QuestionListTile({
    Key? key,
    required this.isContainerVisible,
    required this.question,
  }) : super(key: key);

  @override
  State<QuestionListTile> createState() => _QuestionListTileState();
}

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
///
/// The variable [text] is the text of the correct answer.
class CorrectAnswerContainer extends StatelessWidget {
  final String text;

  CorrectAnswerContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
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
///
/// The variable [question] is the question that is going to be passed to the
/// methods of the buttons.
class MobileButtons extends StatelessWidget {
  final Question question;
  MobileButtons({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditQuizProvider controller = Provider.of<EditQuizProvider>(context, listen: true);
    return Column(
      children: [
        RoundedButton(
          buttonName: 'Edit Question',
          width: 200,
          height: 35,
          fontSize: 13,
          borderColor: Theme.of(context).colorScheme.tertiary,
          backgroundColor: Colors.white,
          textColor: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.normal,
          onPressed: () => controller.editQuestion(context, question),
        ),
        RoundedButton(
          buttonName: 'Delete Question',
          width: 200,
          height: 35,
          fontSize: 13,
          borderColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Colors.white,
          textColor: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.normal,
          onPressed: () => controller.deleteQuestion(context, question),
        ),
      ],
    );
  }
}

/// This widget is used to show the buttons to edit or delete a question on a
/// desktop device. The buttons are displayed next to each each other.
///
/// The variable [question] is the question that is going to be passed to the
/// methods of the buttons.
class DesktopButtons extends StatelessWidget {
  final Question question;
  DesktopButtons({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditQuizProvider controller = Provider.of<EditQuizProvider>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RoundedButton(
          buttonName: 'Delete Question',
          width: 200,
          height: 35,
          fontSize: 13,
          borderColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Colors.white,
          textColor: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.normal,
          onPressed: () => controller.deleteQuestion(context, question),
        ),
        RoundedButton(
          buttonName: 'Edit Question',
          width: 200,
          height: 35,
          fontSize: 13,
          borderColor: Theme.of(context).colorScheme.tertiary,
          backgroundColor: Colors.white,
          textColor: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.normal,
          onPressed: () => controller.editQuestion(context, question),
        ),
      ],
    );
  }
}
