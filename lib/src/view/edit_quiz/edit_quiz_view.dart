/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/edit_quiz/widgets/question_list_tile.dart';
import 'package:queasy/src/view/widgets/rounded-button.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import '../../model/question.dart';
import 'edit_quiz_provider.dart';

/// The enum [AnswersRadioButton] is used to determine which radio button is selected when the user
/// wants to add a question. It refers to the correct answer out of the options.
enum AnswersRadioButton { ans1, ans2, ans3, ans4 }

/// This is the edit quiz view.
///
/// It is the view that the user uses to see their questions from a specific
/// category and edit them. It shows a [ListView] with questions, a button
/// to add a new question, a button to delete the category and a button to
/// create a quiz with random questions.
///
/// The variable [categoryName] is the name of the category that the user is currently in.
///
/// The variable [_category] is the category that the user is currently in.
///
/// The variable [_questions] is a list that stores the questions of the category.
///
/// The variable [controller] is the provider of the class.
///
/// The variable [_isLoading] is a boolean that is used to determine if the view is loading or not.
class EditQuizView extends StatefulWidget {
  final String categoryName;

  EditQuizView({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<EditQuizView> createState() => _EditQuizViewState();
}

class _EditQuizViewState extends State<EditQuizView> {
  get categoryName => widget.categoryName;
  late Category _category;
  late List<Question> _questions;
  late EditQuizProvider controller;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    controller = Provider.of<EditQuizProvider>(context, listen: true);
    controller.questionController = TextEditingController();
    controller.answer1Controller = TextEditingController();
    controller.answer2Controller = TextEditingController();
    controller.answer3Controller = TextEditingController();
    controller.answer4Controller = TextEditingController();
    controller.selectedRadioAnswer = AnswersRadioButton.ans1;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree.
    controller.questionController.dispose();
    controller.answer1Controller.dispose();
    controller.answer2Controller.dispose();
    controller.answer3Controller.dispose();
    controller.answer4Controller.dispose();
    super.dispose();
  }

  init() async {
    _isLoading = true;
    _category = await CategoryRepo().getCategory(categoryName);
    controller.category = _category;
    controller.updateListOfQuestions();
    _questions = await _category.getAllQuestions();
    //print("ok");
    _questions = context.read<EditQuizProvider>().questionList;
    //_questions = controller.questionList;
    //controller.formKeyAddEditQuestion = GlobalKey<FormState>();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditQuizProvider controller =
        Provider.of<EditQuizProvider>(context, listen: true);
    late Widget ListWidget;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      // If there are questions, call the [QuestionList] widget
      // If there are no questions, call the [QuestionListEmpty] widget
      if (_questions.isEmpty) {
        ListWidget = QuestionListEmpty();
      } else {
        ListWidget = QuestionList(questions: _questions);
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _category.getName(), // Show the category name
            style:
                Theme.of(context).textTheme.headline3?.copyWith(fontSize: 22),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,

          // Back button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // Add button
            IconButton(
              icon: Icon(Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => controller.addQuestion(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListWidget,
                CreateAndDeleteButtons(controller: controller),
              ],
            ),
          ),
        ),
      );
    }
  }
}

/// The widget [QuestionList] is used when there are questions in the category. It shows
/// a [ListView] with the questions and when a question is pressed, it
/// shows their answers and the correct answer.
///
/// The variable [questions] is a list that stores the questions of the category.
class QuestionList extends StatefulWidget {
  List<Question> questions;

  QuestionList({
    Key? key,
    required this.questions,
  }) : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  get questions => widget.questions;

  @override
  Widget build(BuildContext context) {
    //EditQuizProvider controller = Provider.of<EditQuizProvider>(context, listen: true);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
        child: Consumer<EditQuizProvider>(
          builder: (context, controller, child) {
            return ListView.builder(
              itemCount: controller.questionList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    child: ExpansionTile(
                      title: Text(
                          //questions[index],
                          controller.questionList[index].text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 15)),
                      children: <Widget>[
                        QuestionListTile(
                            isContainerVisible: true,
                            question: controller.questionList[index]),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// The widget [QuestionListEmpty] is shown when there are no questions in the category.
/// It shows a text that says that there are no questions.
class QuestionListEmpty extends StatelessWidget {
  const QuestionListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Container(
          child: Text(
            'There are no questions yet...\nWhy don\'t you create one?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class CreateAndDeleteButtons extends StatelessWidget {
  final EditQuizProvider controller;

  CreateAndDeleteButtons({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        RoundedButton(
            buttonName: 'Create a random quiz',
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            width: size.width * 0.7,
            height: size.height * 0.06,
            fontSize: 17,
            onPressed: () {
              bool success = controller.createRandomQuiz();
              if (success) {
                final snackBar = SnackBar(
                    content: const Text(
                        'Not implemented yet, be patient')); // TODO: change text
                Future.delayed(Duration.zero, () {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              }
            }),
        SizedBox(height: 4),
        RoundedButton(
          buttonName: 'Delete category',
          backgroundColor: Theme.of(context).colorScheme.secondary,
          width: size.width * 0.7,
          height: size.height * 0.06,
          fontSize: 17,
          onPressed: () => controller.deleteCategory(context),
        ),
      ],
    );
  }
}
