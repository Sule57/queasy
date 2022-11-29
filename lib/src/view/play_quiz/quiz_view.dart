import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/play_quiz/quiz_provider.dart';
import 'package:queasy/src/view/play_quiz/widgets/answer_button.dart';
import 'package:queasy/src/view/play_quiz/widgets/question_container.dart';
import 'package:queasy/src/view/play_quiz/widgets/score_tracking.dart';
import 'package:queasy/src/view/statistics_view.dart';
import 'package:queasy/src/view/widgets/custom_bottom_nav_bar.dart';

/// This is the main quiz view.
///
/// It is the view that the user sees when they are taking a quiz. It shows one
/// [Question] with a number of possible [Answer], and in an answer button
/// press, the view is updated with the data from the next question. When the
/// quiz is over, the user is taken to [StatisticsView].
class QuizView extends StatefulWidget {
  /// Constructor for [QuizView].
  const QuizView({Key? key}) : super(key: key);

  /// Creates a [QuizView] state.
  @override
  State<QuizView> createState() => _QuizViewState();
}

/// State for [QuizView].
class _QuizViewState extends State<QuizView> {
  /// Builds the view.
  ///
  /// Uses a [CustomBottomNavBar] for navigation and a [Stack] to display the
  /// [QuizViewBackground] and the [QuizViewContent] on top.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Quiz View'),
      body: Stack(
        children: [
          const QuizViewBackground(),
          const QuizViewContent(),
        ],
      ),
    );
  }
}

/// Background for [QuizView].
///
/// Uses a [StatelessWidget] to display a background color.
class QuizViewBackground extends StatelessWidget {
  /// Constructor for [QuizViewBackground].
  const QuizViewBackground({Key? key}) : super(key: key);

  /// Builds the background.
  ///
  /// It shows a container of size one third of the screen and with the main
  /// color of [AppThemes].
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height / 3,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }
}

/// Content for [QuizView].
///
/// Uses a [StatefulWidget] to display questions and answers and update the
/// text contained in the widgets.
class QuizViewContent extends StatefulWidget {
  const QuizViewContent({Key? key}) : super(key: key);

  /// Creates a [QuizViewContent] state.
  @override
  State<QuizViewContent> createState() => _QuizViewContentState();
}

/// State for [QuizViewContent].
class _QuizViewContentState extends State<QuizViewContent> {
  @override
  void initState() {
    Provider.of<QuizProvider>(context, listen: false).startTimer();
    super.initState();
  }

  /// Builds the content.
  ///
  /// It uses a [Column] to display the different elements of the view:
  /// [categoryTitle], [scoreTracking], [questionContainer] and [answerButtons].
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .doc('public')
          .collection('Science')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: width,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  Provider.of<QuizProvider>(context).category,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const ScoreTracking(),
                const QuestionContainer(),
                SizedBox(
                  height: height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AnswerButton(index: 0),
                      AnswerButton(index: 1),
                      AnswerButton(index: 2),
                      AnswerButton(index: 3),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    Provider.of<QuizProvider>(context, listen: false).stopTimer();
    super.dispose();
  }
}
