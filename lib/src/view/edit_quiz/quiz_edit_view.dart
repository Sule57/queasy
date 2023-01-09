import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/edit_quiz/quiz_edit_provider.dart';
import 'package:queasy/src/view/edit_quiz/widgets/question_list_tile.dart';
import 'package:queasy/src/view/widgets/rounded-button.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import '../../model/question.dart';

/// This is the quiz edit view.
///
/// It is the view that the user uses to see their questions from a specific
/// category and edit them. It shows a [ListView] with questions and a button
/// to add a new question.

/// The enum [AnswersRadioButton] is used to determine which radio button is selected when the user
/// wants to add a question. It refers to the correct answer out of the options.
enum AnswersRadioButton { ans1, ans2, ans3, ans4 }

/// The widget [QuizEditView] is the main widget of the quiz edit view.
///
/// The variable [_questions] is a list that stores the questions of the category.
/// The variable [_isLoading] is a boolean that is used to determine if the view is loading or not.
class QuizEditView extends StatefulWidget {
  String categoryName;

  QuizEditView({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<QuizEditView> createState() => _QuizEditViewState();
}

class _QuizEditViewState extends State<QuizEditView> {
  get categoryName => widget.categoryName;
  late Category _category;
  late List<Question> _questions;
  late EditQuizProvider controller;
  bool _isLoading = true;

  //late AnswersRadioButton selectedRadioAnswer;
  //AnswersRadioButton selectedRadioAnswer = AnswersRadioButton.ans1;

  @override
  void didChangeDependencies() {
    controller = Provider.of<EditQuizProvider>(context, listen: false);
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

  /// The variable [_isLoading] is used to determine if the view is loading or not. When the async methods
  /// are done loading, the view is not loading anymore.
  ///
  /// The variable [_questions] is a list that stores the questions of the category.
  ///
  /// The variable [_category] is a category object that stores the category of the questions.
  init() async {
    _isLoading = true;
    _category = await CategoryRepo().getCategory(categoryName);
    _questions = await _category.getAllQuestions();
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
    Size size = MediaQuery.of(context).size;
    late Widget ListWidget;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      // If there are questions, call the [QuestionList] widget
      // If there are no questions, call the [QuestionListEmpty] widget
      if (_questions.isEmpty) {
        ListWidget = QuestionListEmpty();
      } else {
        ListWidget = QuestionList(
            questions: _questions,
            //controller: controller,
            //selectedRadioAnswer: selectedRadioAnswer
            );
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _category.getName(), // Show the category name
            style: Theme.of(context).textTheme.headline4,
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
              onPressed: () => controller.addQuestion(context, controller.selectedRadioAnswer),
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
                RoundedButton(
                  buttonName: 'Delete Category',
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  width: size.width * 0.7,
                  height: size.height * 0.06,
                  fontSize: 17,
                  onPressed: () => controller.deleteCategory(context),
                ),
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
  //EditQuizProvider controller;
  //AnswersRadioButton selectedRadioAnswer;
  // TextEditingController questionController;
  // TextEditingController answer1Controller;
  // TextEditingController answer2Controller;
  // TextEditingController answer3Controller;
  // TextEditingController answer4Controller;

  QuestionList({
    Key? key,
    required this.questions,
    //required this.controller,
    //required this.selectedRadioAnswer,
    // required this.questionController,
    // required this.answer1Controller,
    // required this.answer2Controller,
    // required this.answer3Controller,
    // required this.answer4Controller,
  }) : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  get questions => widget.questions;
  //get controller => widget.controller;
  //get selectedRadioAnswer => widget.selectedRadioAnswer;
  // get questionController => widget.questionController;
  // get answer1Controller => widget.answer1Controller;
  // get answer2Controller => widget.answer2Controller;
  // get answer3Controller => widget.answer3Controller;
  // get answer4Controller => widget.answer4Controller;

  @override
  Widget build(BuildContext context) {
    //EditQuizProvider controller = Provider.of<EditQuizProvider>(context, listen: false);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
        child: ListView.builder(
          itemCount: questions.length,
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
                    questions[index].text,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 15)
                  ),
                  children: <Widget>[
                    QuestionListTile(
                      isContainerVisible: true,
                      question: questions[index],
                      // selectedRadioAnswer: controller.selectedRadioAnswer,
                      // questionController: controller.questionController,
                      // answer1Controller: controller.answer1Controller,
                      // answer2Controller: controller.answer2Controller,
                      // answer3Controller: controller.answer3Controller,
                      // answer4Controller: controller.answer4Controller,
                    ),
                  ],
                ),
              ),
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