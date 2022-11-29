import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../quiz_provider.dart';

/// Uses a [Container] with the main color of [AppThemes] to display the text
/// of the current question. Takes the [context] as parameter and a [height]
/// to set the height of the container.
class QuestionContainer extends StatelessWidget {
  const QuestionContainer({
    Key? key,
  }) : super(key: key);

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
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headline3
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
