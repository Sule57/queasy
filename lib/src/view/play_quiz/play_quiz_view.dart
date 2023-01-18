/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/view/play_quiz/play_quiz_provider.dart';
import 'package:queasy/src/view/play_quiz/widgets/answer_button.dart';
import 'package:queasy/src/view/play_quiz/widgets/exit_button.dart';
import 'package:queasy/src/view/play_quiz/widgets/question_container.dart';
import 'package:queasy/src/view/play_quiz/widgets/score_tracking.dart';
import 'package:queasy/src/view/statistics/statistics_view.dart';
import 'package:queasy/src/view/widgets/rounded_button.dart';

/// This is the main quiz view.
///
/// It is the view that the user sees when they are taking a quiz. It shows one
/// [Question] and four [Answer]s, and in an answer button
/// press, the view is updated with the data from the next question. When the
/// quiz is over, the user is taken to [StatisticsView].
///
/// The widget takes a parameter [category] when it is created. This parameter
/// is used to get the questions from the database.
class PlayQuizView extends StatefulWidget {
  final String? category;
  final String? id;

  /// Constructor for [PlayQuizView].
  const PlayQuizView({Key? key, this.category, this.id}) : super(key: key);

  /// Creates a [PlayQuizView] state.
  @override
  State<PlayQuizView> createState() => _PlayQuizViewState();
}

/// State for [PlayQuizView].
///
/// This state is responsible for updating the view when the user answers a
/// question.
///
/// The state has a parameter [category] taken from the widget. This parameter
/// is used to get the questions from the database.
class _PlayQuizViewState extends State<PlayQuizView> {
  get category => widget.category;
  get id => widget.id;

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
          QuizViewContent(category: category, id: id),
        ],
      ),
    );
  }
}

/// Background for [PlayQuizView].
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
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        color: const Color(0xfff1ffe7),
      ),
      child: SafeArea(
        child: Image.asset(
          "lib/assets/images/logo_horizontal.png",
          height: 50,
        ),
      ),
    );
  }
}

/// Content for [PlayQuizView].
///
/// Uses a [StatefulWidget] to display questions and answers and update the
/// text contained in the widgets.
class QuizViewContent extends StatefulWidget {
  const QuizViewContent({Key? key, this.category, this.id}) : super(key: key);

  final String? category;
  final String? id;

  /// Creates a [QuizViewContent] state.
  @override
  State<QuizViewContent> createState() => _QuizViewContentState();
}

/// State for [QuizViewContent].
class _QuizViewContentState extends State<QuizViewContent> {
  String? category;
  String? id;
  bool isLoading = true;

  init() async {
    category = widget.category;
    id = widget.id;

    isLoading = await context
        .read<PlayQuizProvider>()
        .startQuiz(category: category, id: id);

    category = context.read<PlayQuizProvider>().quizCategory;

    Provider.of<PlayQuizProvider>(context, listen: false).startTimer();

    setState(() {});
  }

  /// Constructs the quiz from the database and starts the timer for the first
  /// time.
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // /// Function called when [QuizView] is active again on screen. It restarts the
  // /// timer and starts the quiz.
  // @override
  // void didChangeDependencies() {
  //   print('Quiz view activated');
  //   Provider.of<QuizProvider>(context, listen: false).resetTimer();
  //   context
  //       .read<QuizProvider>()
  //       .startQuiz(category: category, numberOfQuestions: 5);
  //   super.didChangeDependencies();
  // }

  /// This function is called every time [PlayQuizView] stops being displayed on
  /// screen. It stops the timer.
  @override
  void deactivate() {
    print("Quiz View deactivated");
    Provider.of<PlayQuizProvider>(context, listen: false).stopTimer();
    super.deactivate();
  }

  /// Builds the content depending on the screen size, with a threshold of 700
  /// pixels. If the screen is smaller than 700 pixels, the function displays
  /// [QuizViewMobileContent]. Otherwise, it displays [QuizViewDesktopContent].
  /// It also displays a [CircularProgressIndicator] while the quiz is loading.
  /// When the quiz is loaded, the [CircularProgressIndicator] is replaced by
  /// the content.
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : width < 700
            ? QuizViewMobileContent()
            : QuizViewDesktopContent();
  }
}

/// Content for [PlayQuizView] on desktop devices and bigger screens. It shows
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
          Container(
            alignment: Alignment.topRight,
            width: width / 3,
            child: RoundedButton(
              buttonName: 'Exit',
              fontSize: 18,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ),
          Text(
            Provider.of<PlayQuizProvider>(context).quizCategory,
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

/// Content for [PlayQuizView] on mobile devices and smaller screens. It shows
/// the question and the answers in one column.
class QuizViewMobileContent extends StatelessWidget {
  const QuizViewMobileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        width: width,
        padding: const EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ExitButton(),
            ),
            Text(
              Provider.of<PlayQuizProvider>(context).quizCategory,
              style: Theme.of(context).textTheme.headline2,
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
      ),
    );
  }
}
