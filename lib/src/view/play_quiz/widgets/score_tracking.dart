import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../quiz_provider.dart';

/// Uses a [Row] to display the current points of the user as well as the
/// count of questions answered so far out of the total number of questions.
/// Takes the [context] as parameter.
class ScoreTracking extends StatelessWidget {
  const ScoreTracking({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pointTracker = Provider.of<QuizProvider>(context).pointTracker();
    String questionTracker =
        Provider.of<QuizProvider>(context).questionTracker();
    String timeLeft = Provider.of<QuizProvider>(context).timeLeft;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(timeLeft),
          Text(pointTracker),
          Text(questionTracker),
        ],
      ),
    );
  }
}
