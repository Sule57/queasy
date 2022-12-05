import 'package:flutter/material.dart';
import 'package:queasy/src/view/widgets/rounded-button.dart';

/// This is the quiz edit view.
///
/// It is the view that the user uses to see their questions from a specific
/// category and edit them. It shows a [ListView] with questions and a button
/// to add a new question. It uses colors from [AppThemes].

/// This [enum] is used to determine which radio button is selected when the user
/// wants to add a question. If refers to the correct answer out of the options.
enum AnswersRadioButton { ans1, ans2, ans3, ans4 }

/// This is the [enum] value of the selected radio button for when the user
/// adds a new question.
AnswersRadioButton? _selectedRadioAnswer = AnswersRadioButton.ans1;

class QuizEditView extends StatefulWidget {
  const QuizEditView({Key? key}) : super(key: key);

  @override
  State<QuizEditView> createState() => _QuizEditViewState();
}

class _QuizEditViewState extends State<QuizEditView> {
  Future<void> deleteCategory() async {
    // TODO: implement deleteCategory
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // TODO: get category name from selected category
        title: Text(
          '<Category Name>',
          style: Theme.of(context).textTheme.headline4,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,

        /// Back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          /// Add button
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
              // TODO: if statement to check if there are any questions
              // If there are questions, call the QuestionList widget
              // If there are no questions, call the QuestionListEmpty widget
              QuestionList(),
              //QuestionListEmpty(),
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

  addQuestion() {
    // TODO: Add question to database
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrEditQuestionPopUp();
      },
    );
  }
}

/// This widget is used when there are questions in the category. It shows
/// a [ListView] with the questions and when a question is pressed, it
/// shows their answers and the correct answer.
class QuestionList extends StatefulWidget {
  const QuestionList({Key? key}) : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  // TODO: Get questions and answers from database
  getQuestionsAndAnswers() {}

  // Dummy data
  List<String> questions = [
    'Question 1',
    'Question 2',
    'Question 3',
    'Question 4',
    'Question 5',
    'Question 6',
    'Question 7',
    'Question 8',
    'Question 9',
    'Question 10',
    'Question 11',
    'Question 12',
  ];

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
                    questions[index],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  children: <Widget>[
                    QuestionListTile(isContainerVisible: true),
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

/// This widget is shown when there are no questions in the category.
class QuestionListEmpty extends StatelessWidget {
  const QuestionListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Container(
          child: Text('There are questions yet...\nWhy don\'t you create one?'),
        ),
      ],
    );
  }
}

class QuestionListTile extends StatefulWidget {
  /// [isContainerVisible] determines the size of the container
  final bool isContainerVisible;

  // TODO: add parameters. QuestionListTile should receive a Question object
  // so I can get the question, the answers and the correct answer and show
  // them in the container.

  const QuestionListTile({
    Key? key,
    required this.isContainerVisible,
  }) : super(key: key);

  @override
  State<QuestionListTile> createState() => _QuestionListTileState();
}

class _QuestionListTileState extends State<QuestionListTile> {
  get isContainerVisible => widget.isContainerVisible;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        height: isContainerVisible ? 180 : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TODO: Get answers from database
            // TODO: highlight the correct answer
            Text('Answer 1'),
            Text('Answer 2'),
            Text('Answer 3'),
            Text('Answer 4'),
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

  deleteQuestion() {
    // TODO: Delete question from database
    // Show a dialog to confirm the deletion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteQuestionPopUp();
      },
    );
  }

  editQuestion() {
    // TODO: Edit question
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrEditQuestionPopUp();
      },
    );
  }
}

/// This widget shows an [AlertDialog] to confirm the deletion of a question.
/// If the user confirms the deletion, the question is deleted from the database.
/// If the user cancels the deletion, the [AlertDialog] is closed.
class DeleteQuestionPopUp extends StatelessWidget {
  const DeleteQuestionPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Question',
          style: TextStyle(color: Colors.white)),
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
              // TODO: Add functionality to the confirm button.
              onPressed: () => Navigator.pop(context),
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

/// This widget shows a [AlertDialog] with a form to add or edit a new question.
/// It shows a [TextFormField] for the question, four [TextFormField]s for the
/// options, and four [Radio]s for the correct answer.
/// The [validator]s check if the fields are empty or null.
class AddOrEditQuestionPopUp extends StatelessWidget {
  const AddOrEditQuestionPopUp({
    Key? key,

    /// These parameters are used to set the initial values of the fields
    /// when the user edits a question, instead of adding a new one.
    String? question,
    String? answer1,
    String? answer2,
    String? answer3,
    String? answer4,
    int? correctAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      /// This makes the dialog scrollable if the content is too big for the screen,
      /// especially when the user clicks on the text field to type and the keyboard
      /// pops up, taking up a lot of space.
      scrollable: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),

      /// [StatefulBuilder] is used to rebuild the widget when the user
      /// selects a radio button for the correct answer. Otherwise, the
      /// radio button would not change when the user selects a different one.
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            child: Form(
              // TODO: add key
              //key: _formKeyAddQuestion, _formKeyEditQuestion // do i need both?
              child: Column(
                /// This makes the dialog have the smallest needed height.
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          // If field is null or full of empty spaces
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a question';
                          }
                          return null;
                        },
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
                            _selectedRadioAnswer = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                            _selectedRadioAnswer = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                            _selectedRadioAnswer = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                            _selectedRadioAnswer = value;
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

      /// Cancel and confirm buttons.
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
              // TODO: Add functionality to the confirm button.
              onPressed: () => Navigator.pop(context),
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
