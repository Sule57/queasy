/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../quiz_provider.dart';

/// Widget to display questions of the quiz.
class QuestionContainer extends StatelessWidget {
  const QuestionContainer({
    Key? key,
  }) : super(key: key);

  /// Builds the view.
  ///
  /// It displays a container with color of the main color of the theme. It
  /// displays the text of the question aligned to the center. This text
  /// is updated every time the user answers a question.
  @override
  Widget build(BuildContext context) {
    String text = Provider.of<QuizProvider>(context).getCurrentQuestionText();
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height / 5,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          )),
    );
  }
}
