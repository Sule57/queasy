/// ****************************************************************************
/// Created by Julia Agüero
/// Collaborators: Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../src.dart';
import '../play_quiz/play_quiz_view.dart';
import 'widgets/quiz_question_list_tile.dart';

/// Displays the questions of the quiz using a list of [QuizQuestionListTile].
///
/// It takes a parameter [quizId] when it is created, that is used to get the
/// quiz from the list of quizzes in the [MyQuizzesProvider].
class QuizQuestionsView extends StatefulWidget {
  /// Id of the quiz whose questions are being displayed.
  final String quizId;

  /// Constructor for the [QuizQuestionsView].
  const QuizQuestionsView({
    Key? key,
    required this.quizId,
  }) : super(key: key);

  /// Creates the state for this widget.
  @override
  State<QuizQuestionsView> createState() => _QuizQuestionsViewState();
}

/// State for the [QuizQuestionsView].
class _QuizQuestionsViewState extends State<QuizQuestionsView> {
  /// Id of the quiz whose questions are being displayed. It is taken from the
  /// widget, passed as parameter when it is created.
  get quizId => widget.quizId;

  /// Boolean used to show or hide the [CircularProgressIndicator] while the
  /// questions are being loaded.
  bool _isLoading = true;

  /// Function that is called when the state is initialized.
  ///
  /// It updates the data in [MyQuizzesProvider] to take the questions of the
  /// quiz with the id [quizId]. Once the questions are loaded, it sets the
  /// [_isLoading] to false.
  void init() async {
    await Provider.of<MyQuizzesProvider>(context, listen: false)
        .updateCurrentQuizDisplaying(quizId);
    setState(() {
      _isLoading = false;
    });
  }

  /// Called when the state is initialized. It calls the [init] function.
  @override
  void initState() {
    init();
    super.initState();
  }

  /// Builds the view.
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final provider = Provider.of<MyQuizzesProvider>(context);
    // List<Question> questionList = provider.quizDisplaying!.questions!;

    TextStyle? headlineTextStyle = theme.textTheme.headline3;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                provider.quizDisplaying.name!,
                style: headlineTextStyle,
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                // icon button to share quiz id to clipboard
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: quizId));

                    Future.delayed(Duration.zero, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Copied to clipboard'),
                        ),
                      );
                    });
                  },
                  color: theme.colorScheme.onBackground,
                ),
              ],
            ),
            body: SafeArea(
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: height * 0.715,
                      child: ListView.builder(
                        itemCount: provider.quizDisplaying.questions!.length,
                        itemBuilder: (context, index) {
                          // print(provider.quizDisplaying!.questions![0].text);
                          // print(provider.quizDisplaying!.questions![1].text);
                          // print(provider.quizDisplaying!.questions![2].text);
                          // print('index: $index');
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: QuizQuestionListTile(index: index),
                          );
                        },
                      ),
                    ),
                    width < 700
                        ? Column(
                            children: [
                              ElevatedButton(
                                child: const Text('Play quiz'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.tertiary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => PlayQuizView(
                                        id: quizId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Delete quiz'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  provider.deleteQuiz(quizId);
                                },
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: const Text('Play quiz'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.tertiary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => PlayQuizView(
                                          id: quizId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  child: const Text('Delete quiz'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    provider.deleteQuiz(quizId);
                                  },
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
  }
}
