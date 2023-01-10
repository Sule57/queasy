/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:queasy/src/view/edit_quiz/edit_quiz_view.dart';
import 'package:queasy/src/view/edit_quiz/widgets/edit_quiz_popups.dart';
import '../../../src.dart';

/// This is the edit quiz provider.
///
/// It is the provider that the [EditQuizView] uses to get the questions of a
/// specific category and to edit them, add more or delete them.
///
/// The variable [_questions] is a list that stores the questions of the category.
///
/// The variable [_isLoading] is a boolean that is used to determine if the view is loading or not.
///
/// The variable [_category] is the category that the user is currently in.
///
/// The variable [questionController] is the controller for the question text field.
/// The variable [answer1Controller] is the controller for the first answer text field.
/// The variable [answer2Controller] is the controller for the second answer text field.
/// The variable [answer3Controller] is the controller for the third answer text field.
/// The variable [answer4Controller] is the controller for the fourth answer text field.
///
/// The variable [_selectedRadioAnswer] is the variable that stores the selected radio button.
class EditQuizProvider with ChangeNotifier {
  late Category _category;

  Category get category => _category;

  set category(Category category) {
    _category = category;
  }

  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController answer3Controller = TextEditingController();
  TextEditingController answer4Controller = TextEditingController();

  AnswersRadioButton _selectedRadioAnswer = AnswersRadioButton.ans1;

  AnswersRadioButton get selectedRadioAnswer => _selectedRadioAnswer;

  set selectedRadioAnswer(AnswersRadioButton value) {
    _selectedRadioAnswer = value;
  }

  /// The method [addQuestion] is used to show a dialog to add a question to the category.
  ///
  /// The variable [context] is used to show the dialog.
  addQuestion(BuildContext context) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddOrEditQuestionPopUp(
              categoryName: _category.getName(),
              action: () {
                addQuestionToDatabase(_category);
              },
            );
          });
    });
    notifyListeners();
  }

  /// The method [deleteCategory] is used to show a dialog to delete a category from the database.
  ///
  /// The variable [context] is used to show the dialog.
  deleteCategory(BuildContext context) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeleteCategoryPopUp(category: _category.getName());
          });
    });
    notifyListeners();
  }

  /// This method [editQuestionOnDatabase] used to edit a question on the database.
  ///
  /// The variable [question] is the question that is going to be edited.
  editQuestionOnDatabase(Question question) async {
    print(questionController.text);
    question.setText(questionController.text.toString());
    question.answers[0].setText(answer1Controller.text);
    question.answers[1].setText(answer2Controller.text);
    question.answers[2].setText(answer3Controller.text);
    question.answers[3].setText(answer4Controller.text);
    question.setCorrectAnswer(_selectedRadioAnswer.index);
    await question.updateQuestion();
    print("Question edited");
    //notifyListeners();
  }

  /// The method [addQuestionToDatabase] is used to add a question to the database.
  ///
  /// The variable [question] is the question that is going to be added.
  /// The variable [category] is the category that the question is going to be added to.
  addQuestionToDatabase(Category _category) async {
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
      category: _category.getName(),
    );
    await _category.createQuestion(question);
    print("Question added");
    //print("Question: $questionController.text]");
    //notifyListeners();
  }

  /// The method [deleteQuestion] is used to show a dialog to delete a question from the database.
  ///
  /// The variable [context] is used to show the dialog.
  /// The variable [question] is the question that is going to be deleted.
  deleteQuestion(BuildContext context, Question question) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeleteQuestionPopUp(question: question);
          });
    });
    notifyListeners();
  }

  /// The method [editQuestion] is used to show a dialog to edit a question.
  ///
  /// The variable [context] is used to show the dialog.
  /// The variable [question] is the question that is going to be edited.
  editQuestion(BuildContext context, Question question) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddOrEditQuestionPopUp(
              categoryName: question.category,
              action: () {
                editQuestionOnDatabase(question);
              },
              question: question,
            );
          });
    });
    notifyListeners();
  }

  /// The method [createRandomQuiz] is used to create a quiz with random questions and
  /// store it in the database.
  bool createRandomQuiz() {
    // Check if there are question in the category. If not, no quiz can be created
    if (category.getAllQuestions() == []) { // TODO: fix condition
      print("No questions in category");
      // Show an alert that says the quiz cannot be created because there are no
      // questions in the category
      return false;
    } else {
      //print("Creating random quiz");
      // get random questions from the database
      // TODO
      // store the quiz in the database
      // TODO
      return true;
    }
  }

  /// The method [getCorrectRadioAnswer] gets the correct answer of a [question] and returns the
  /// corresponding radio button.
  AnswersRadioButton getCorrectRadioAnswer(Question question) {
    if (question.answers[0].isCorrect) {
      return AnswersRadioButton.ans1;
    } else if (question.answers[1].isCorrect) {
      return AnswersRadioButton.ans2;
    } else if (question.answers[2].isCorrect) {
      return AnswersRadioButton.ans3;
    } else {
      return AnswersRadioButton.ans4;
    }
  }

  /// The method [clearTextFieldsAndButton] clears all text fields and resets the radio button
  /// of the popup controllers that create or edit a question.
  void clearTextFieldsAndButton() {
    questionController.clear();
    answer1Controller.clear();
    answer2Controller.clear();
    answer3Controller.clear();
    answer4Controller.clear();
    selectedRadioAnswer = AnswersRadioButton.ans1;
  }
}
