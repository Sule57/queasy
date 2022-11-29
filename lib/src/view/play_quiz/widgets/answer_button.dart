import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../quiz_provider.dart';

class AnswerButton extends StatelessWidget {
  final int index;

  const AnswerButton({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var provider = Provider.of<QuizProvider>(context);
    String text = provider.getAnswerText(index);
    bool isCorrect = provider.isAnswerCorrect(index);

    return Container(
      height: height / 14,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<QuizProvider>().editScore(isCorrect);
          context.read<QuizProvider>().nextQuestion();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: isCorrect ? Colors.green : Colors.red,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
