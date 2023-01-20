/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';

/// List tile used to display the information of each question.
///
/// It is used in [QuizQuestionsView] to display the questions of the quiz.
/// It takes a parameter [index] when it is created, that is used to get the
/// question from the list of questions in the [MyQuizzesProvider].
class QuizQuestionListTile extends StatefulWidget {
  /// Constructor for the [QuizQuestionListTile].
  const QuizQuestionListTile({Key? key, required this.index}) : super(key: key);

  /// Index of the question in the list of questions of the quiz.
  final int index;

  /// Creates the state for this widget.
  @override
  State<QuizQuestionListTile> createState() => _QuizQuestionListTileState();
}

/// State for the [QuizQuestionListTile].
class _QuizQuestionListTileState extends State<QuizQuestionListTile> {
  /// Builds the widget.
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

/// Widget used to display the text of the answer.
///
/// It is used in [QuizQuestionListTile] to display the answers of the question.
/// It takes a parameter [answer] when it is created, that is used to get the
/// text of the answer.
class AnswerText extends StatelessWidget {
  /// Constructor for the [AnswerText].
  const AnswerText({Key? key, required this.answer}) : super(key: key);

  /// [Answer] to display.
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
