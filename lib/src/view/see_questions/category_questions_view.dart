/// ****************************************************************************
/// Created by Sophia Soares
/// Collaborators: Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/see_questions/widgets/questions_popups.dart';
import 'package:queasy/src/view/see_questions/widgets/question_list_tile.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import '../../../constants/theme_provider.dart';
import '../../model/question.dart';
import 'category_questions_provider.dart';

/// The enum [AnswersRadioButton] is used to determine which radio button is selected when the user
/// wants to add a question. It refers to the correct answer out of the options.
enum AnswersRadioButton { ans1, ans2, ans3, ans4 }

/// This is the Category Question view.
///
/// It is the view that the user uses to see their questions from a specific
/// category and edit them. It shows a [ListView] with questions, a button
/// to add a new question, a button to delete the category and a button to
/// create a quiz with random questions.
class CategoryQuestionsView extends StatefulWidget {
  final String categoryName;

  CategoryQuestionsView({Key? key, required this.categoryName})
      : super(key: key);

  @override
  State<CategoryQuestionsView> createState() => _CategoryQuestionsViewState();
}

class _CategoryQuestionsViewState extends State<CategoryQuestionsView> {
  /// Name of the category that the user is currently in.
  get categoryName => widget.categoryName;

  /// Category that the user is currently in.
  late Category _category;

  /// Stores the questions of the category.
  late List<Question> _questions;

  /// Is the provider of the class.
  late CategoryQuestionsProvider controller;

  /// Used to determine if the view is loading or not.
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    controller = Provider.of<CategoryQuestionsProvider>(context, listen: true);
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

  /// Called when the view is build for the first time, it initializes the
  /// [_category] and [_questions] calling the database and sets [_isLoading] to false once the
  /// data is loaded.
  init() async {
    _isLoading = true;
    _category = await CategoryRepo().getCategory(categoryName);
    controller.category = _category;
    await controller.updateQuestionsFromCategory();
    _questions = context.read<CategoryQuestionsProvider>().questionList;
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
    CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context);
    _questions = controller.questionList;
    late Widget ListWidget;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      // If there are questions, call the [QuestionList] widget
      // If there are no questions, call the [QuestionListEmpty] widget
      if (_questions.isEmpty) {
        ListWidget = QuestionListEmpty();
      } else {
        ListWidget = QuestionList();
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 16.0, right: 16.0),
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
  QuestionList({Key? key}) : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
        child: Consumer<CategoryQuestionsProvider>(
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
                      title: Text(controller.questionList[index].text,
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
  final CategoryQuestionsProvider controller;

  CreateAndDeleteButtons({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: size.height * 0.05,
                child: ElevatedButton(
                  child: Text('Custom quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (controller.questionList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You should create a question first, don\'t you think?'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => CreateCustomQuizPopup());
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: size.height * 0.05,
                child: ElevatedButton(
                  child: Text('Random quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (controller.questionList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You should create a question first, don\'t you think?'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => CreateRandomQuizPopup());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: size.height * 0.05,
          child: ElevatedButton(
            onPressed: () => controller.deleteCategory(context),
            child: Text('Delete category'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
