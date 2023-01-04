import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queasy/src/view/widgets/rounded-button.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import '../model/answer.dart';
import '../model/question.dart';

/// This is the quiz edit view.
///
/// It is the view that the user uses to see their questions from a specific
/// category and edit them. It shows a [ListView] with questions and a button
/// to add a new question.

/// The enum [AnswersRadioButton] is used to determine which radio button is selected when the user
/// wants to add a question. If refers to the correct answer out of the options.
enum AnswersRadioButton { ans1, ans2, ans3, ans4 }

// TODO: get the category from the previous view and delete dummy data
Category _category = Category(name: 'technology', color: Colors.blue);

/// The variables [questionController], [ans1Controller], [ans2Controller], [ans3Controller], [ans4Controller]
/// are used to store and manage the text that the user inputs in the text fields.
final TextEditingController questionController = TextEditingController();
final TextEditingController answer1Controller = TextEditingController();
final TextEditingController answer2Controller = TextEditingController();
final TextEditingController answer3Controller = TextEditingController();
final TextEditingController answer4Controller = TextEditingController();

/// The variable [_selectedRadioAnswer] is used to store the value of the selected radio button.
AnswersRadioButton _selectedRadioAnswer = AnswersRadioButton.ans1;

/// The widget [QuizEditView] is the main widget of the quiz edit view.
/// It
/// The variable [_questions] is a list that stores the questions of the category.
/// The variable [_isLoading] is a boolean that is used to determine if the view is loading or not.
class QuizEditView extends StatefulWidget {
  const QuizEditView({Key? key}) : super(key: key);

  @override
  State<QuizEditView> createState() => _QuizEditViewState();
}

class _QuizEditViewState extends State<QuizEditView> {
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

  /// This method is used to delete a category from the database.
  Future<void> deleteThisCategory() async {
    print('Category deleted');
    // TODO: TEST IT
    await CategoryRepo().deleteCategory(_category.getName());
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
        ListWidget = QuestionList(questions: _questions);
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
              onPressed: () => addQuestion(),
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
                  onPressed: deleteThisCategory,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// This method is used to add a question to the database.
  addQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrEditQuestionPopUp(action: () {
          addQuestionToDatabase();
        });
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

  QuestionList({
    Key? key,
    required this.questions,
  }) : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  get questions => widget.questions;

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
                        isContainerVisible: true, question: questions[index]),
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
          child: Text('There are questions yet...\nWhy don\'t you create one?',
              textAlign: TextAlign.center),
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

  QuestionListTile({
    Key? key,
    required this.isContainerVisible,
    required this.question,
  }) : super(key: key);

  @override
  State<QuestionListTile> createState() => _QuestionListTileState();
}

class _QuestionListTileState extends State<QuestionListTile> {
  get isContainerVisible => widget.isContainerVisible;
  get question => widget.question;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        height: isContainerVisible ? 180 : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TODO: highlight the correct answer
            Text(question.answers[0].text),
            Text(question.answers[1].text),
            Text(question.answers[2].text),
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
    // TODO: Delete question from database
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
  /// to edit the question text and then call the method [editQuestionInDatabase]
  /// to edit the question in the database.
  editQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrEditQuestionPopUp(
            action: () {
              editQuestionToDatabase(question);
            },
            question: question);
      },
    );
  }
}

// TODO fix editQuestionText method
/// This method is used to edit a question in the database.
///
/// The variable [question] is the question that is going to be edited.
editQuestionToDatabase(Question question) async {
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
addQuestionToDatabase() async {
  Question question = Question(
    text: questionController.text,
    answers: [
      Answer(answer1Controller.text,
          _selectedRadioAnswer.index == 0 ? true : false),
      Answer(answer2Controller.text,
          _selectedRadioAnswer.index == 1 ? true : false),
      Answer(answer3Controller.text,
          _selectedRadioAnswer.index == 2 ? true : false),
      Answer(answer4Controller.text,
          _selectedRadioAnswer.index == 3 ? true : false),
    ],
    // TODO: remove hard-code
    category: _category.getName(),
    questionId: '0',
  );
  await _category.createQuestion(question);
  print("Question added");
}

/// The widget [DeleteQuestionPopUp] shows an [AlertDialog] to confirm the deletion of a question.
///
/// The variable [question] is the question that is going to be deleted.
class DeleteQuestionPopUp extends StatelessWidget {
  const DeleteQuestionPopUp({Key? key, required question}) : super(key: key);

  get question => question;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text('Delete Question', style: TextStyle(color: Colors.white)),
      content: const Text('Are you sure you want to delete this question?',
          style: TextStyle(color: Colors.white)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            TextButton(
              onPressed: () async {
                // TODO: uncomment this line
                //await question.deleteQuestion();
                print('Question deleted');
                Navigator.pop(context);
              },
              child: Text('Confirm'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The widget [AddOrEditQuestionPopUp] shows an [AlertDialog] with a form to add or edit a new question.
///
/// It shows a [TextFormField] for the question, four [TextFormField]s for the
/// options, and four [Radio]s for the correct answer.
///
/// The [validator]s check if the fields are empty or null.
///
/// The [question] variable is the question that is going to be edited. If it is null,
/// then the question is going to be added.
///
/// The [action] variable is the function that is going to be called when the user
/// confirms the addition or edition of the question.
///
/// The [_formKey] is used to validate the form.
///
/// The [_selectedRadioAnswer] is the index of the correct answer.
///
/// The [_category] is the category of the question.
///
/// The [MAX_LENGTH] is the maximum number of characters that can be entered in the
/// [TextFormField]s.
///
/// [StatefulBuilder] is used to rebuild the widget when the user
/// selects a radio button for the correct answer.
class AddOrEditQuestionPopUp extends StatefulWidget {
  Function() action;
  Question? question;

  AddOrEditQuestionPopUp({
    Key? key,
    this.question,
    required this.action,
  }) : super(key: key);

  @override
  State<AddOrEditQuestionPopUp> createState() => _AddOrEditQuestionPopUpState();
}

class _AddOrEditQuestionPopUpState extends State<AddOrEditQuestionPopUp> {
  // This [GlobalKey] is used to validate the form.
  final _formKey = GlobalKey<FormState>();

  int MAX_INPUT_LENGTH = 35;

  get question => widget.question;

  // TODO: predefine radio button value for editing

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // This makes the dialog scrollable if the content is too big for the screen,
      // especially when the user clicks on the text field to type and the keyboard
      // pops up, taking up a lot of space.
      scrollable: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // StatefulBuilder otherwise, the radio button would not change when the user selects a different one.
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            child: Form(
              key: _formKey,
              //key: _formKeyAddQuestion, _formKeyEditQuestion // do i need both?
              child: Column(
                // This makes the dialog have the smallest needed height.
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: questionController
                          ..text = question == null ? '' : question.getText(),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(MAX_INPUT_LENGTH)
                        ],
                        validator: (value) {
                          // If field is null or full of empty spaces
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a question';
                          }
                          return null;
                        },
                        // onFieldSubmitted: (String value) {
                        //   setState(() {
                        //     questionController.text = value;
                        //   });
                        // },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Question',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text('Correct', style: TextStyle(color: Colors.white)),
                  ]),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: answer1Controller
                            ..text = question == null
                                ? ''
                                : question.answers[0].text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(MAX_INPUT_LENGTH)
                          ],
                          validator: (value) {
                            // If field is null or full of empty spaces
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Answer 1',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Radio<AnswersRadioButton>(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: AnswersRadioButton.ans1,
                        groupValue: _selectedRadioAnswer,
                        onChanged: (AnswersRadioButton? value) {
                          setState(() {
                            _selectedRadioAnswer = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: answer2Controller
                            ..text = question == null
                                ? ''
                                : question.answers[1].text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(MAX_INPUT_LENGTH)
                          ],
                          validator: (value) {
                            // If field is null or full of empty spaces
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Answer 2',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Radio<AnswersRadioButton>(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: AnswersRadioButton.ans2,
                        groupValue: _selectedRadioAnswer,
                        onChanged: (AnswersRadioButton? value) {
                          setState(() {
                            _selectedRadioAnswer = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: answer3Controller
                            ..text = question == null
                                ? ''
                                : question.answers[2].text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(MAX_INPUT_LENGTH)
                          ],
                          validator: (value) {
                            // If field is null or full of empty spaces
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Answer 3',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Radio<AnswersRadioButton>(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: AnswersRadioButton.ans3,
                        groupValue: _selectedRadioAnswer,
                        onChanged: (AnswersRadioButton? value) {
                          setState(() {
                            _selectedRadioAnswer = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: answer4Controller
                            ..text = question == null
                                ? ''
                                : question.answers[3].text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(MAX_INPUT_LENGTH)
                          ],
                          validator: (value) {
                            // If field is null or full of empty spaces
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Answer 4',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Radio<AnswersRadioButton>(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: AnswersRadioButton.ans4,
                        groupValue: _selectedRadioAnswer,
                        onChanged: (AnswersRadioButton? value) {
                          setState(() {
                            _selectedRadioAnswer = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Cancel and confirm buttons.
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                // Clear all text fields
                clearTextFieldsAndButton();
                Navigator.pop(context);
              },
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            TextButton(
              child: Text('Confirm'),
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  foregroundColor: Theme.of(context).colorScheme.onTertiary,
                  backgroundColor: Theme.of(context).colorScheme.tertiary),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Call the function to add/edit the question to the/in database.
                  widget.action();
                  clearTextFieldsAndButton();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  /// This method clears all text fields and resets the radio button.
  void clearTextFieldsAndButton() {
    questionController.clear();
    answer1Controller.clear();
    answer2Controller.clear();
    answer3Controller.clear();
    answer4Controller.clear();
    _selectedRadioAnswer = AnswersRadioButton.ans1;
  }
}
