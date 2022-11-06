import 'package:flutter/material.dart';

import 'package:queasy/controller/quiz_view_controller.dart';
import 'package:queasy/view/widgets/custom_bottom_nav_bar.dart';

class QuizView extends StatefulWidget {
  final QuizzViewController controller = QuizzViewController();

  QuizView({Key? key}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Quiz View'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width,
              child: Text(
                controller.getQuestionText(),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _answerButton(0),
                _answerButton(1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _answerButton(2),
                _answerButton(3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerButton(int index) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        child: Text(controller.getAnswerText(index)),
      ),
    );
  }
}
