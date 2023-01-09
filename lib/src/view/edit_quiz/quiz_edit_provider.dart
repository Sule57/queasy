import 'package:flutter/material.dart';
import 'package:queasy/src/view/edit_quiz/quiz_edit_view.dart';
import 'package:queasy/src/view/edit_quiz/widgets/edit_quiz_popups.dart';
import 'package:queasy/src/view/edit_quiz/widgets/question_list_tile.dart';

import '../../../src.dart';

class EditQuizProvider with ChangeNotifier {

  late Category _category;
  get category => _category;

  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController answer3Controller = TextEditingController();
  TextEditingController answer4Controller = TextEditingController();

  /// The variable [_selectedRadioAnswer] is used to store the value of the selected radio button.
  AnswersRadioButton _selectedRadioAnswer = AnswersRadioButton.ans1;
  AnswersRadioButton get selectedRadioAnswer => _selectedRadioAnswer;
  set selectedRadioAnswer(AnswersRadioButton value) {
    _selectedRadioAnswer = value;
    notifyListeners();
  }

  EditQuizProvider() {
    init();
  }

  void init() async {
    _category = await CategoryRepo().getCategory("Sophia Category"); // TODO: fix this, remove hard code
  }

  /// This method is used to add a question to the database.
  addQuestion(BuildContext context, AnswersRadioButton _selectedRadioAnswer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrEditQuestionPopUp(
            // questionController: questionController,
            // answer1Controller: answer1Controller,
            // answer2Controller: answer2Controller,
            // answer3Controller: answer3Controller,
            // answer4Controller: answer4Controller,
            categoryName: _category.getName(),
            action: () {
              addQuestionToDatabase(
                  _category,
                  //questionController,
                  //answer1Controller,
                  // answer2Controller,
                  // answer3Controller,
                  // answer4Controller,
                  // _selectedRadioAnswer
              );
              print('refrescarei');
              // Refresh the view to show the new question
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuizEditView(categoryName: _category.getName()),
                ),
              );
              print('refresquei');
            },
            //selectedRadioAnswer: _selectedRadioAnswer
        );
      },
    );
    notifyListeners(); // TODO: in or out of the dialog?
  }

  /// This method is used to delete a category from the database.
  deleteCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteCategoryPopUp(category: _category.getName());
      },
    );
    notifyListeners();
  }

  // TODO fix editQuestionText method
  /// This method is used to edit a question in the database.
  ///
  /// The variable [question] is the question that is going to be edited.
  editQuestionOnDatabase(
      Question question,
      // TextEditingController questionController,
      // TextEditingController answer1Controller,
      // TextEditingController answer2Controller,
      // TextEditingController answer3Controller,
      // TextEditingController answer4Controller,
      //AnswersRadioButton _selectedRadioAnswer
      ) async {
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
      // TODO: fix this
      // the texts are being null, probably because the text controllers are
      // empty because its not passing
      Category _category,
      // TextEditingController questionController,
      // TextEditingController answer1Controller,
      // TextEditingController answer2Controller,
      // TextEditingController answer3Controller,
      // TextEditingController answer4Controller,
      // AnswersRadioButton _selectedRadioAnswer
      ) async {
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

  /// This method is used to, indirectly, delete a question.
  ///
  /// [showDialog] shows a pop-up with a [DeleteQuestionPopUp] widget
  /// to confirm the deletion of the question and then calls the method
  /// [deleteQuestionFromDatabase] to delete the question from the database.
  deleteQuestion(BuildContext context, Question question) {
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
  editQuestion(BuildContext context, Question question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrEditQuestionPopUp(
          // questionController: questionController,
          // answer1Controller: answer1Controller,
          // answer2Controller: answer2Controller,
          // answer3Controller: answer3Controller,
          // answer4Controller: answer4Controller,
          categoryName: question.category,
          action: () {
            editQuestionOnDatabase(
                question,
                // questionController,
                // answer1Controller,
                // answer2Controller,
                // answer3Controller,
                // answer4Controller,
                // selectedRadioAnswer
            );
          },
          question: question,
          //selectedRadioAnswer: selectedRadioAnswer
        );
      },
    );
  }

}