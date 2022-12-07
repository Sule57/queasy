import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/play_quiz/quiz_provider.dart';
import 'package:queasy/src/view/play_quiz/widgets/answer_button.dart';
import 'package:queasy/src/view/play_quiz/widgets/question_container.dart';
import 'package:queasy/src/view/play_quiz/widgets/score_tracking.dart';
import 'package:queasy/src/view/statistics_view.dart';

/// This is the main quiz view.
///
/// It is the view that the user sees when they are taking a quiz. It shows one
/// [Question] with a number of possible [Answer], and in an answer button
/// press, the view is updated with the data from the next question. When the
/// quiz is over, the user is taken to [StatisticsView].
class QuizView extends StatefulWidget {
  final String category;

  /// Constructor for [QuizView].
  const QuizView({Key? key, required this.category}) : super(key: key);

  /// Creates a [QuizView] state.
  @override
  State<QuizView> createState() => _QuizViewState();
}

/// State for [QuizView].
class _QuizViewState extends State<QuizView> {
  get category => widget.category;

  /// Builds the view.
  ///
  /// Uses a custom bottom navigation bar for navigation and a [Stack] to display the
  /// [QuizViewBackground] and the [QuizViewContent] on top.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QuizViewBackground(),
          QuizViewContent(category: category),
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
      width: double.infinity,
      color: Theme.of(context).colorScheme.onPrimary,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Image.asset(
          "lib/assets/images/logo_horizontal.png",
          height: 50,
        ),
      ),
    );
  }
}

/// Content for [QuizView].
///
/// Uses a [StatefulWidget] to display questions and answers and update the
/// text contained in the widgets.
class QuizViewContent extends StatefulWidget {
  const QuizViewContent({Key? key, required this.category}) : super(key: key);

  final String category;

  /// Creates a [QuizViewContent] state.
  @override
  State<QuizViewContent> createState() => _QuizViewContentState();
}

/// State for [QuizViewContent].
class _QuizViewContentState extends State<QuizViewContent> {
  get category => widget.category;

  @override
  void initState() {
    context
        .read<QuizProvider>()
        .startQuiz(category: category, numberOfQuestions: 5);
    Provider.of<QuizProvider>(context, listen: false).startTimer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('Quiz view activated');
    Provider.of<QuizProvider>(context, listen: false).resetTimer();
    context
        .read<QuizProvider>()
        .startQuiz(category: category, numberOfQuestions: 5);
    super.didChangeDependencies();
  }

  /// Builds the content.
  ///
  /// It uses a [Column] to display the different elements of the view:
  /// [categoryTitle], [scoreTracking], [questionContainer] and [answerButtons].
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .doc('public')
          .collection(category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return width < 700
              ? const QuizViewMobileContent()
              : const QuizViewDesktopContent();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void deactivate() {
    print("Quiz View deactivated");
    Provider.of<QuizProvider>(context, listen: false).stopTimer();
    super.deactivate();
  }

  // @override
  // void dispose() {
  //   Provider.of<QuizProvider>(context, listen: false).stopTimer();
  //   super.dispose();
  // }
}

class QuizViewDesktopContent extends StatelessWidget {
  const QuizViewDesktopContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.center,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width / 10, vertical: 20),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    children: const [
                      AnswerButton(index: 0),
                      SizedBox(width: 10),
                      AnswerButton(index: 1),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: const [
                      AnswerButton(index: 2),
                      SizedBox(width: 10),
                      AnswerButton(index: 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuizViewMobileContent extends StatelessWidget {
  const QuizViewMobileContent({Key? key}) : super(key: key);

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
          Text(
            Provider.of<QuizProvider>(context).category,
            style: Theme.of(context).textTheme.headline1,
          ),
          const ScoreTracking(),
          const QuestionContainer(),
          SizedBox(
            height: height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                AnswerButton(index: 0),
                SizedBox(height: 10),
                AnswerButton(index: 1),
                SizedBox(height: 10),
                AnswerButton(index: 2),
                SizedBox(height: 10),
                AnswerButton(index: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
