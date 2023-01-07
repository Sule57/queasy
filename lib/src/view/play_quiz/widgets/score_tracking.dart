import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../quiz_provider.dart';

/// Widget to display the score, the current question being answered, and the
/// time left.
class ScoreTracking extends StatelessWidget {
  const ScoreTracking({
    Key? key,
  }) : super(key: key);

  /// Builds the view.
  ///
  /// Uses a [Row] to display the time left, the current points of the user and
  /// count of questions answered so far out of the total number of questions.
  /// The time gets updated every second and the points and question count get
  /// updated every time the user answers a question.
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
          Text(timeLeft,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              )),
          Text(pointTracker,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              )),
          Text(
            questionTracker,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
