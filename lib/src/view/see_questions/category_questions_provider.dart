/// ****************************************************************************
/// Created by Sophia Soares
/// Collaborator: Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:queasy/src/view/see_questions/category_questions_view.dart';
import 'package:queasy/src/view/see_questions/widgets/questions_popups.dart';
import '../../../src.dart';
import '../../../utils/exceptions.dart';

/// This is the category questions provider.
///
/// It is the provider that the [CategoryQuestionsView] uses to get the questions of a
/// specific category and to edit them, add more or delete them.
class CategoryQuestionsProvider with ChangeNotifier {

  /// The category that the user is currently in.
  late Category _category;

  Category get category => _category;

  set category(Category category) {
    _category = category;
  }

  /// Stores the questions of the category.
  late List<Question> _questionList = [];

  List<Question> get questionList => _questionList;

  /// Checks if the question is checked or not.
  List<bool> _isQuestionChecked = [];

  List<bool> get isQuestionChecked => _isQuestionChecked;

  set questionList(List<Question> questionList) {
    _questionList = questionList;
    _isQuestionChecked = List.filled(_questionList.length, false);
  }

  /// Stores the categories of the user.
  late List<String> _categoryList = [];

  List<String> get categoryList => _categoryList;

  set categoryList(List<String> categoryList) {
    _categoryList = categoryList;
  }

  /// The controller for the question text field.
  TextEditingController questionController = TextEditingController();

  /// The controller for the first answer text field.
  TextEditingController answer1Controller = TextEditingController();

  /// The controller for the second answer text field.
  TextEditingController answer2Controller = TextEditingController();

  /// The controller for the third answer text field.
  TextEditingController answer3Controller = TextEditingController();

  /// The controller for the fourth answer text field.
  TextEditingController answer4Controller = TextEditingController();

  /// The controller for the number of questions.
  TextEditingController numberOfQuestionsController = TextEditingController();

  /// The controller for the name of the quiz.
  TextEditingController newQuizNameController = TextEditingController();

  /// The variable that stores the selected radio button.
  AnswersRadioButton _selectedRadioAnswer = AnswersRadioButton.ans1;

  AnswersRadioButton get selectedRadioAnswer => _selectedRadioAnswer;

  set selectedRadioAnswer(AnswersRadioButton value) {
    _selectedRadioAnswer = value;
  }

  /// Form key to add or edit a question.
  GlobalKey<FormState> formKeyAddEditQuestion = GlobalKey<FormState>();

  /// Form key to create a random quiz.
  GlobalKey<FormState> formKeyCreateRandomQuiz = GlobalKey<FormState>();

  /// Form key to create a custom quiz.
  GlobalKey<FormState> formKeyCreateCustomQuiz = GlobalKey<FormState>();

  /// The method [updateQuestionsFromCategory] is used to get the questions of a category to be displayed in the
  /// [CategoryQuestionsView].
  ///
  /// It calls the database and stores the questions in the [questionList].
  Future<void> updateQuestionsFromCategory() async {
    questionList = await category.getAllQuestions();
    _isQuestionChecked = List.filled(_questionList.length, false);
    notifyListeners();
  }

  /// The method [updateListOfCategories] updates the list of categories to be displayed in the
  /// [PrivateCategorySelectionView].
  ///
  /// It gets the categories from the database and stores them in the [categoryList].
  Future<void> updateListOfCategories() async {
    categoryList = await CategoryRepo().getPrivateCategories();
    notifyListeners();
  }

  /// The method [updateQuestionsFromQuiz] is used to update the questions of a quiz to be
  /// displayed in the [QuizQuestionsView].
  ///
  /// It gets the questions from the database and stores them in the [questionList].
  ///
  /// It takes the id of the quiz as a parameter.
  Future<void> updateQuestionsFromQuiz(String id) async {
    await Quiz().retrieveQuizFromId(id: id).then((quiz) {
      questionList = quiz.questions;
    });
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
              categoryName: category.getName(),
              action: () async {
                await addQuestionToDatabase();
              },
            );
          });
    });
  }

  /// The method [addQuestionToDatabase] is used to add a question to the database.
  ///
  /// The variable [question] is the question that is going to be added.
  ///
  /// The variable [category] is the category that the question is going to be added to.
  Future<void> addQuestionToDatabase() async {
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
      category: category.getName(),
    );
    await category.createQuestion(question);
    await updateQuestionsFromCategory();
  }

  /// The method [editQuestion] is used to show a dialog to edit a question.
  ///
  /// The variable [context] is used to show the dialog.
  ///
  /// The variable [question] is the question that is going to be edited.
  editQuestion(BuildContext context, Question question) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddOrEditQuestionPopUp(
              categoryName: question.category,
              question: question,
              action: () async{
                await editQuestionOnDatabase(question);
              },
            );
          });
    });
  }

  /// This method [editQuestionOnDatabase] used to edit a question on the database.
  ///
  /// The variable [question] is the question that is going to be edited.
  Future<void> editQuestionOnDatabase(Question question) async {
    question.setText(questionController.text.toString());
    question.answers[0].setText(answer1Controller.text);
    question.answers[1].setText(answer2Controller.text);
    question.answers[2].setText(answer3Controller.text);
    question.answers[3].setText(answer4Controller.text);
    question.setCorrectAnswer(_selectedRadioAnswer.index);
    await question.updateQuestion();
    notifyListeners();
  }

  /// The method [deleteQuestion] is used to show a dialog to delete a question from the database.
  ///
  /// The variable [context] is used to show the dialog.
  ///
  /// The variable [question] is the question that is going to be deleted.
  deleteQuestion(BuildContext context, Question question) {
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeleteQuestionPopUp(question: question);
          });
    });
  }

  /// This method [deleteQuestionFromDatabase] used to delete a question from the database.
  ///
  /// The variable [question] is the question that is going to be deleted.
  Future<void> deleteQuestionFromDatabase(Question question) async {
    await category.deleteQuestion(question);
    await updateQuestionsFromCategory();
    notifyListeners();
  }

  /// The method [addCategoryToDatabase] creates a new category and adds it to the database.
  ///
  /// The variable [name] is the name of the category that is going to be created.
  Future<void> addCategoryToDatabase(String name) async {
    // Check if the category already exists
    if ((await CategoryRepo().getPrivateCategories()).contains(name)) {
      throw CategoryAlreadyExistsException();
    } else {
      await CategoryRepo().createCategory(name, Colors.blue);
      await updateListOfCategories();
      notifyListeners();
    }
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
  }

  /// This method [deleteCategoryFromDatabase] used to delete a category from the database.
  Future<void> deleteCategoryFromDatabase() async {
    await CategoryRepo().deleteCategory(category.getName());
    await updateListOfCategories();
    notifyListeners();
  }

  /// The method [createAndStoreRandomQuiz] is used to create a quiz with random questions and
  /// store it in the database.
  ///
  /// It returns a Future<String?> with the id of the quiz that was created.
  ///
  /// This id will be null if the quiz was not created successfully.
  Future<String?> createAndStoreRandomQuiz() async {
    int numberOfQuestions = int.parse(numberOfQuestionsController.text);
    String quizName = newQuizNameController.text;
    String? quizId;

    if (numberOfQuestions > questionList.length) {
      numberOfQuestions = questionList.length;
    }

    await Quiz()
        .getRandomQuestions(
            name: quizName,
            category: Category(name: category.getName()),
            noOfQuestions: numberOfQuestions,
            isPublic: false)
        .then((quiz) async {
      await quiz.storeQuiz();
      quizId = quiz.id;
    });

    return quizId;
  }

  /// The method [createAndStoreCustomQuiz] is used to create a quiz with custom questions and
  /// store it in the database.
  ///
  /// It takes a parameter [questionIds] which is the list of ids of the questions
  /// that are going to be store in the custom quiz.
  ///
  /// It returns a Future<String?> with the id of the quiz that was created.
  ///
  /// This id will be null if the quiz was not created successfully.
  Future<String?> createAndStoreCustomQuiz({
    required List<String> questionIds,
  }) async {
    String quizName = newQuizNameController.text;
    String? quizId;
    // List<String> questionIds = ['question0', 'question1', 'question2'];
    await Quiz()
        .createCustomQuiz(
      questions: questionIds,
      category: category,
      name: quizName,
    )
        .then((quiz) async {
      await quiz.storeQuiz();
      quizId = quiz.id;
    });

    return quizId;
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

  /// The method [updateIsQuestionChecked] updates the value of the variable [isQuestionChecked].
  void updateIsQuestionChecked({required int index, required bool value}) {
    _isQuestionChecked[index] = value;
    notifyListeners();
  }

  /// The method [clearIsQuestionChecked] clears the [isQuestionChecked].
  void clearIsQuestionChecked() {
    _isQuestionChecked = List.filled(_questionList.length, false);
    notifyListeners();
  }
}
