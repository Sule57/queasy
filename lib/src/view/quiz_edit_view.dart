import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queasy/src/view/widgets/rounded-button.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import '../model/answer.dart';
import '../model/question.dart';
import 'package:queasy/src/view/widgets/edit_quiz_popups.dart';

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

  /// The variables [questionController], [ans1Controller], [ans2Controller], [ans3Controller], [ans4Controller]
  /// are used to store and manage the text that the user inputs in the text fields.
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answer1Controller = TextEditingController();
  final TextEditingController answer2Controller = TextEditingController();
  final TextEditingController answer3Controller = TextEditingController();
  final TextEditingController answer4Controller = TextEditingController();

  /// The variable [_selectedRadioAnswer] is used to store the value of the selected radio button.
  AnswersRadioButton _selectedRadioAnswer = AnswersRadioButton.ans1;

  QuizEditView({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<QuizEditView> createState() => _QuizEditViewState();
}

class _QuizEditViewState extends State<QuizEditView> {
  get categoryName => widget.categoryName;
  late Category _category;

  get questionController => widget.questionController;
  get answer1Controller => widget.answer1Controller;
  get answer2Controller => widget.answer2Controller;
  get answer3Controller => widget.answer3Controller;
  get answer4Controller => widget.answer4Controller;
  get _selectedRadioAnswer => widget._selectedRadioAnswer;

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree.
    questionController.dispose();
    answer1Controller.dispose();
    answer2Controller.dispose();
    answer3Controller.dispose();
    answer4Controller.dispose();
    super.dispose();
  }

  late List<Question> _questions;
  bool _isLoading = true;

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
            selectedRadioAnswer: _selectedRadioAnswer,
            questionController: questionController,
            answer1Controller: answer1Controller,
            answer2Controller: answer2Controller,
            answer3Controller: answer3Controller,
            answer4Controller: answer4Controller);
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            // Add button
            IconButton(
              icon: Icon(Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => addQuestion(_selectedRadioAnswer),
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
                  onPressed: deleteCategory,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// This method is used to add a question to the database.
  addQuestion(_selectedRadioAnswer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrEditQuestionPopUp(
            questionController: questionController,
            answer1Controller: answer1Controller,
            answer2Controller: answer2Controller,
            answer3Controller: answer3Controller,
            answer4Controller: answer4Controller,
            categoryName: categoryName,
            action: () {
              addQuestionToDatabase(
                  _category,
                  questionController,
                  answer1Controller,
                  answer2Controller,
                  answer3Controller,
                  answer4Controller,
                  _selectedRadioAnswer);
              print('refrescarei');
              // Refresh the view to show the new question
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuizEditView(categoryName: categoryName),
                ),
              );
              print('refresquei');
            },
            selectedRadioAnswer: _selectedRadioAnswer);
      },
    );
  }

  /// This method is used to delete a category from the database.
  deleteCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteCategoryPopUp(category: _category.getName());
      },
    );
  }
}

/// The widget [QuestionList] is used when there are questions in the category. It shows
/// a [ListView] with the questions and when a question is pressed, it
/// shows their answers and the correct answer.
///
/// The variable [questions] is a list that stores the questions of the category.
class QuestionList extends StatefulWidget {
  List<Question> questions;
  AnswersRadioButton selectedRadioAnswer;
  TextEditingController questionController;
  TextEditingController answer1Controller;
  TextEditingController answer2Controller;
  TextEditingController answer3Controller;
  TextEditingController answer4Controller;

  QuestionList({
    Key? key,
    required this.questions,
    required this.selectedRadioAnswer,
    required this.questionController,
    required this.answer1Controller,
    required this.answer2Controller,
    required this.answer3Controller,
    required this.answer4Controller,
  }) : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  get questions => widget.questions;
  get selectedRadioAnswer => widget.selectedRadioAnswer;
  get questionController => widget.questionController;
  get answer1Controller => widget.answer1Controller;
  get answer2Controller => widget.answer2Controller;
  get answer3Controller => widget.answer3Controller;
  get answer4Controller => widget.answer4Controller;

  // Dummy data
  // List<String> questions = [
  //   'Question 1',
  //   'Question 2',
  //   'Question 3',
  //   'Question 4',
  //   'Question 5',
  //   'Question 6',
  //   'Question 7',
  //   'Question 8',
  //   'Question 9',
  //   'Question 10',
  //   'Question 11',
  //   'Question 12',
  // ];

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  children: <Widget>[
                    QuestionListTile(
                      isContainerVisible: true,
                      question: questions[index],
                      selectedRadioAnswer: selectedRadioAnswer,
                      questionController: questionController,
                      answer1Controller: answer1Controller,
                      answer2Controller: answer2Controller,
                      answer3Controller: answer3Controller,
                      answer4Controller: answer4Controller,
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
              // TODO: test size for mobile
              fontSize: MediaQuery.of(context).size.width < 700 ? 14 : 18,
            ),
          ),
        ),
      ],
    );
  }
}

/// The widget [QuestionListTile] is used to show a question and its answers.
///
/// The variable [question] is the question that is going to be shown.
///
/// The variable [isContainerVisible] is used to show or hide the container that
/// contains the answers.
///
/// The [RoundedButton] widgets are used to edit or delete the question.
class QuestionListTile extends StatefulWidget {
  /// [isContainerVisible] determines the size of the container
  final bool isContainerVisible;
  Question question;
  AnswersRadioButton selectedRadioAnswer;
  TextEditingController questionController;
  TextEditingController answer1Controller;
  TextEditingController answer2Controller;
  TextEditingController answer3Controller;
  TextEditingController answer4Controller;

  QuestionListTile({
    Key? key,
    required this.isContainerVisible,
    required this.question,
    required this.selectedRadioAnswer,
    required this.questionController,
    required this.answer1Controller,
    required this.answer2Controller,
    required this.answer3Controller,
    required this.answer4Controller,
  }) : super(key: key);

  @override
  State<QuestionListTile> createState() => _QuestionListTileState();
}

class _QuestionListTileState extends State<QuestionListTile> {
  get isContainerVisible => widget.isContainerVisible;
  get question => widget.question;
  get selectedRadioAnswer => widget.selectedRadioAnswer;
  get questionController => widget.questionController;
  get answer1Controller => widget.answer1Controller;
  get answer2Controller => widget.answer2Controller;
  get answer3Controller => widget.answer3Controller;
  get answer4Controller => widget.answer4Controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        height: isContainerVisible ? 180 : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TODO: highlight the correct answer
            if (question.answers[0].isCorrect)
              CorrectAnswerContainer(text: question.answers[0].text)
            else
              Text(question.answers[0].text),
            if (question.answers[1].isCorrect)
              CorrectAnswerContainer(text: question.answers[1].text)
            else
              Text(question.answers[1].text),
            if (question.answers[2].isCorrect)
              CorrectAnswerContainer(text: question.answers[2].text)
            else
              Text(question.answers[2].text),
            if (question.answers[3].isCorrect)
              CorrectAnswerContainer(text: question.answers[3].text)
            else
              Text(question.answers[3].text),
            RoundedButton(
              buttonName: 'Edit Question',
              width: 200,
              height: 35,
              fontSize: 13,
              borderColor: Theme.of(context).colorScheme.tertiary,
              backgroundColor: Colors.white,
              textColor: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.normal,
              onPressed: editQuestion,
            ),
            RoundedButton(
              buttonName: 'Delete Question',
              width: 200,
              height: 35,
              fontSize: 13,
              borderColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Colors.white,
              textColor: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.normal,
              onPressed: deleteQuestion,
            ),
          ],
        ),
      ),
    );
  }

  /// This method is used to, indirectly, delete a question.
  ///
  /// [showDialog] shows a pop-up with a [DeleteQuestionPopUp] widget
  /// to confirm the deletion of the question and then calls the method
  /// [deleteQuestionFromDatabase] to delete the question from the database.
  deleteQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteQuestionPopUp(question: question);
      },
    );
  }

  /// This method is used to, indirectly, edit a question.
  ///
  /// [showDialog] shows a pop-up with a [AddOrEditQuestionPopUp] widget
  /// to edit the question text and then call the method [editQuestionOnDatabase]
  /// to edit the question in the database.
  editQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrEditQuestionPopUp(
            questionController: questionController,
            answer1Controller: answer1Controller,
            answer2Controller: answer2Controller,
            answer3Controller: answer3Controller,
            answer4Controller: answer4Controller,
            categoryName: question.category,
            action: () {
              editQuestionOnDatabase(
                  question,
                  questionController,
                  answer1Controller,
                  answer2Controller,
                  answer3Controller,
                  answer4Controller,
                  selectedRadioAnswer);
            },
            question: question,
            selectedRadioAnswer: selectedRadioAnswer);
      },
    );
  }
}

// TODO fix editQuestionText method
/// This method is used to edit a question in the database.
///
/// The variable [question] is the question that is going to be edited.
editQuestionOnDatabase(
    Question question,
    TextEditingController questionController,
    TextEditingController answer1Controller,
    TextEditingController answer2Controller,
    TextEditingController answer3Controller,
    TextEditingController answer4Controller,
    AnswersRadioButton _selectedRadioAnswer) async {
  print(questionController.text);
  question.setText(questionController.text.toString());
  question.answers[0].setText(answer1Controller.text);
  question.answers[1].setText(answer2Controller.text);
  question.answers[2].setText(answer3Controller.text);
  question.answers[3].setText(answer4Controller.text);
  question.setCorrectAnswer(_selectedRadioAnswer.index);
  await question.updateQuestion();
  print("Question edited");
}

/// This method is used to add a question to the database.
///
/// The variable [question] is the question that is going to be added.
addQuestionToDatabase(
    Category _category,
    TextEditingController questionController,
    TextEditingController answer1Controller,
    TextEditingController answer2Controller,
    TextEditingController answer3Controller,
    TextEditingController answer4Controller,
    AnswersRadioButton _selectedRadioAnswer) async {
  Question question = Question(
    text: questionController.text,
    answers: [
      // TODO: fix the correct answer that is being sent wrong
      Answer(answer1Controller.text,
          _selectedRadioAnswer.index == 0 ? true : false),
      Answer(answer2Controller.text,
          _selectedRadioAnswer.index == 1 ? true : false),
      Answer(answer3Controller.text,
          _selectedRadioAnswer.index == 2 ? true : false),
      Answer(answer4Controller.text,
          _selectedRadioAnswer.index == 3 ? true : false),
    ],
    category: _category.getName(),
  );
  await _category.createQuestion(question);
  print("Question added");
}

// TODO: test it
class CorrectAnswerContainer extends StatelessWidget {
  String text;

  CorrectAnswerContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
