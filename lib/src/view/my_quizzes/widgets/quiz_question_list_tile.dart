/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';

class QuizQuestionListTile extends StatefulWidget {
  const QuizQuestionListTile({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<QuizQuestionListTile> createState() => _QuizQuestionListTileState();
}

class _QuizQuestionListTileState extends State<QuizQuestionListTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final provider = Provider.of<MyQuizzesProvider>(context);
    Question question = provider.quizDisplaying.questions![widget.index];

    TextStyle? questionTextStyle = theme.textTheme.headline4.copyWith(
      fontWeight: FontWeight.normal,
    );

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          //questions[index],
          question.text,
          style: questionTextStyle,
        ),
        children: [
          AnswerText(answer: question.answers[0]),
          AnswerText(answer: question.answers[1]),
          AnswerText(answer: question.answers[2]),
          AnswerText(answer: question.answers[3]),
        ],
      ),
    );
  }
}

class AnswerText extends StatelessWidget {
  const AnswerText({Key? key, required this.answer}) : super(key: key);
  final Answer answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: answer.isCorrect
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2.0,
              ),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(answer.text, style: TextStyle(fontSize: 15)),
      ),
    );
  }
}
