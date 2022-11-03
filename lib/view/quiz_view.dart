import 'package:flutter/material.dart';
import 'package:queasy/controller/quiz_view_controller.dart';

import 'package:queasy/model/answer.dart';
import 'package:queasy/model/question.dart';

class QuizView extends StatefulWidget {
  const QuizView({Key? key}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  Question question = Question(
    'What is the capital of Germany?',
    [
      Answer('Berlin', true),
      Answer('Hamburg', false),
      Answer('Munich', false),
      Answer('Frankfurt', false),
    ],
  );

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
                question.text,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(question.answers[0].text),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // getQuestion("science", "question0");
                  },
                  child: Text(question.answers[1].text),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(question.answers[2].text),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(question.answers[3].text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
