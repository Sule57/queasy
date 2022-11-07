import 'package:flutter/material.dart';

import 'package:queasy/controller/quiz_view_controller.dart';
import 'package:queasy/view/widgets/custom_bottom_nav_bar.dart';

class QuizView extends StatefulWidget {
  final QuizViewController controller = QuizViewController();

  QuizView({Key? key}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Quiz View'),
      body: Stack(
        children: [
          const QuizViewBackground(),
          QuizViewContent(controller),
        ],
      ),
    );
  }
}

class QuizViewBackground extends StatelessWidget {
  const QuizViewBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height / 3,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }
}

class QuizViewContent extends StatelessWidget {
  final QuizViewController controller;

  const QuizViewContent(this.controller, {Key? key}) : super(key: key);

  Widget categoryTitle(BuildContext context) {
    return Text(
      controller.category,
      style: Theme.of(context).textTheme.headline2,
    );
  }

  Widget scoreTracking(BuildContext context) {
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
          Text('${controller.totalPoints} points'),
          Text(
              "${controller.currentQuestionIndex + 1} / ${controller.totalQuestions}"),
        ],
      ),
    );
  }

  Container questionContainer(BuildContext context, double height) {
    return Container(
      height: height / 5,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        controller.getQuestionText(),
        style: Theme.of(context)
            .textTheme
            .headline3
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  Widget answerButtons(BuildContext context, double height) {
    Widget singleAnswerButton(BuildContext context, int index) {
      return Container(
        height: height / 14,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(controller.getAnswerText(index),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1),
        ),
      );
    }

    return Container(
      height: height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          singleAnswerButton(context, 0),
          singleAnswerButton(context, 1),
          singleAnswerButton(context, 2),
          singleAnswerButton(context, 3),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          categoryTitle(context),
          scoreTracking(context),
          questionContainer(context, height),
          answerButtons(context, height),
        ],
      ),
    );
  }
}
