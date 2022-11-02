import 'package:flutter/material.dart';

import 'package:queasy/model/answer.dart';

class QuizView extends StatefulWidget {
  const QuizView({Key? key}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  String text = "This is the text of the first question.";
  Answer answer1 = Answer("Answer 1", true);
  Answer answer2 = Answer("Answer 2", true);
  Answer answer3 = Answer("Answer 3", true);
  Answer answer4 = Answer("Answer 4", true);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: _width,
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(answer1.text),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(answer2.text),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(answer3.text),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(answer4.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
