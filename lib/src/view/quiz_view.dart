import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/controller/quiz_view_controller.dart';
import 'package:queasy/src/view/statistics_view.dart';
import 'package:queasy/src/view/widgets/custom_bottom_nav_bar.dart';

/// This is the main quiz view.
///
/// It is the view that the user sees when they are taking a quiz. It shows one
/// [Question] with a number of possible [Answer], and in an answer button
/// press, the view is updated with the data from the next question. When the
/// quiz is over, the user is taken to [StatisticsView].
class QuizView extends StatefulWidget {
  /// Controller to connect to [Quiz], [User] and [Question] models.
  final QuizViewController controller = QuizViewController();

  /// Constructor for [QuizView].
  QuizView({Key? key}) : super(key: key);

  /// Creates a [QuizView] state.
  @override
  State<QuizView> createState() => _QuizViewState();
}

/// State for [QuizView].
class _QuizViewState extends State<QuizView> {
  /// Getter for the controller in the state.
  get controller => widget.controller;

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
          QuizViewContent(controller),
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
  /// Controller to connect to [Quiz], [User] and [Question] models. Passed from
  /// [QuizView].
  final QuizViewController controller;

  /// Constructor for [QuizViewContent]. It takes a [QuizViewController] as
  /// parameter to connect to the model.
  const QuizViewContent(this.controller, {Key? key}) : super(key: key);

  /// Creates a [QuizViewContent] state.
  @override
  State<QuizViewContent> createState() => _QuizViewContentState();
}

/// State for [QuizViewContent].
class _QuizViewContentState extends State<QuizViewContent> {
  /// Getter for the controller in the state.
  get controller => widget.controller;

  /// Shows text with category of the quiz that is being currently played. It
  /// takes the [context] as parameter.
  Widget categoryTitle(BuildContext context) {
    /// Text with the category of the quiz.
    String category = controller.category;

    return Text(
      category,
      style: Theme.of(context).textTheme.headline2,
    );
  }

  /// Uses a [Row] to display the current points of the user as well as the
  /// count of questions answered so far out of the total number of questions.
  /// Takes the [context] as parameter.
  Widget scoreTracking(BuildContext context) {
    /// Current points of the user.
    int points = controller.points;

    /// Number of the question that the user is currently answering.
    int currentQuestionIndex = controller.currentQuestionIndex;

    /// Total number of questions in the quiz.
    int totalQuestions = controller.totalQuestions;

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
          Text('$points points'),
          Text("${currentQuestionIndex + 1} / $totalQuestions"),
        ],
      ),
    );
  }

  /// Uses a [Container] with the main color of [AppThemes] to display the text
  /// of the current question. Takes the [context] as parameter and a [height]
  /// to set the height of the container.
  Container questionContainer(BuildContext context, double height) {
    /// Text of the current question.
    String questionText = controller.getQuestionText();

    return Container(
      height: height / 5,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        questionText,
        style: Theme.of(context)
            .textTheme
            .headline3
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  /// Uses a [Column] to display the possible answers for the current question.
  /// Takes the [context] as parameter and a [height] to set the height of the
  /// container where the buttons for the answers are displayed.
  Widget answerButtons(BuildContext context, double height) {
    /// Function to create a single answer button.
    ///
    /// Takes the [context] as parameter and the [answerIndex] to access to the
    /// right answer.
    /// On a button pressed, the current score is edited and the data of the
    /// next question of the quiz is displayed on the view. If there are no more
    /// questions, the current points of the user are saved and the user is
    /// taken to [StatisticsView].
    Widget singleAnswerButton(BuildContext context, int answerIndex) {
      /// Text of the answer.
      String answerText = controller.getAnswerText(answerIndex);

      /// Boolean to check if the answer is correct.
      bool isCorrect = controller.isCorrectAnswer(answerIndex);

      return Container(
        height: height / 14,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              controller.editScore(isCorrect);

              if (!controller.nextQuestion()) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const StatisticsView(),
                ));
              }
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: isCorrect ? Colors.green : Colors.red,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(answerText,
              textAlign: TextAlign.center,
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

  /// Builds the content.
  ///
  /// It uses a [Column] to display the different elements of the view:
  /// [categoryTitle], [scoreTracking], [questionContainer] and [answerButtons].
  @override
  Widget build(BuildContext context) {
    /// Width of the screen.
    double width = MediaQuery.of(context).size.width;

    /// Height of the screen.
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
