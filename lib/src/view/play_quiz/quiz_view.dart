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
/// [Question] and four [Answer]s, and in an answer button
/// press, the view is updated with the data from the next question. When the
/// quiz is over, the user is taken to [StatisticsView].
///
/// The widget takes a parameter [category] when it is created. This parameter
/// is used to get the questions from the database.
class QuizView extends StatefulWidget {
  final String category;

  /// Constructor for [QuizView].
  const QuizView({Key? key, required this.category}) : super(key: key);

  /// Creates a [QuizView] state.
  @override
  State<QuizView> createState() => _QuizViewState();
}

/// State for [QuizView].
///
/// This state is responsible for updating the view when the user answers a
/// question.
///
/// The state has a parameter [category] taken from the widget. This parameter
/// is used to get the questions from the database.
class _QuizViewState extends State<QuizView> {
  get category => widget.category;

  /// Builds the view.
  ///
  /// Uses a [Stack] to display the [QuizViewBackground], and the
  /// [QuizViewContent] on top.
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
/// Uses a [StatelessWidget] to display the background colors.
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

  /// Constructs the quiz from the database and starts the timer for the first
  /// time.
  @override
  void initState() {
    context
        .read<QuizProvider>()
        .startQuiz(category: category, numberOfQuestions: 5);
    Provider.of<QuizProvider>(context, listen: false).startTimer();
    super.initState();
  }

  /// Function called when [QuizView] is active again on screen. It restarts the
  /// timer and starts the quiz.
  @override
  void didChangeDependencies() {
    print('Quiz view activated');
    Provider.of<QuizProvider>(context, listen: false).resetTimer();
    context
        .read<QuizProvider>()
        .startQuiz(category: category, numberOfQuestions: 5);
    super.didChangeDependencies();
  }

  /// Builds the content depending on the screen size, with a threshold of 700
  /// pixels. If the screen is smaller than 700 pixels, the function displays
  /// [QuizViewMobileContent]. Otherwise, it displays [QuizViewDesktopContent].
  /// The builder takes a stream of [QuerySnapshot]s from the database and
  /// displays the questions only when they are loaded. Until then, it displays
  /// a [CircularProgressIndicator].
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

  /// This function is called everytime [QuizView] stops being displayed on
  /// screen. It stops the timer.
  @override
  void deactivate() {
    print("Quiz View deactivated");
    Provider.of<QuizProvider>(context, listen: false).stopTimer();
    super.deactivate();
  }
}

/// Content for [QuizView] on desktop devices and bigger screens. It shows
/// the question and the answer in 2 rows of 2 columns.
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

/// Content for [QuizView] on mobile devices and smaller screens. It shows
/// the question and the answers in one column.
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
