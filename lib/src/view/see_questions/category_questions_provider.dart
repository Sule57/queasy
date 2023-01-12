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

/// This is the edit quiz provider.
///
/// It is the provider that the [CategoryQuestionsView] uses to get the questions of a
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
class CategoryQuestionsProvider with ChangeNotifier {
  late Category _category;

  Category get category => _category;

  set category(Category category) {
    _category = category;
  }

  //List<Question> _questionList = [];
  late List<Question> _questionList;
  List<Question> get questionList => _questionList;

  List<bool> _isQuestionChecked = [];
  List<bool> get isQuestionChecked => _isQuestionChecked;

  set questionList(List<Question> questionList) {
    _questionList = questionList;
    _isQuestionChecked = List.filled(_questionList.length, false);
  }

  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController answer3Controller = TextEditingController();
  TextEditingController answer4Controller = TextEditingController();

  TextEditingController numberOfQuestionsController = TextEditingController();
  TextEditingController newQuizNameController = TextEditingController();

  AnswersRadioButton _selectedRadioAnswer = AnswersRadioButton.ans1;
  AnswersRadioButton get selectedRadioAnswer => _selectedRadioAnswer;

  set selectedRadioAnswer(AnswersRadioButton value) {
    _selectedRadioAnswer = value;
  }

  GlobalKey<FormState> formKeyAddEditQuestion = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCreateRandomQuiz = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCreateCustomQuiz = GlobalKey<FormState>();

  void updateQuestionsFromCategory() async {
    questionList = await category.getAllQuestions();
    _isQuestionChecked = List.filled(_questionList.length, false);
    notifyListeners();
  }

  void updateQuestionsFromQuiz(String id) async {
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
              action: () {
                addQuestionToDatabase();
              },
            );
          });
    });
  }

  /// The method [addQuestionToDatabase] is used to add a question to the database.
  ///
  /// The variable [question] is the question that is going to be added.
  /// The variable [category] is the category that the question is going to be added to.
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
      category: category.getName(),
    );
    await category.createQuestion(question);
    updateQuestionsFromCategory();
    print("Question added");
    //print("Question: $questionController.text]");
    // notifyListeners();
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
              question: question,
              action: () {
                editQuestionOnDatabase(question);
              },
            );
          });
    });
  }

  /// This method [editQuestionOnDatabase] used to edit a question on the database.
  ///
  /// The variable [question] is the question that is going to be edited.
  editQuestionOnDatabase(Question question) async {
    question.setText(questionController.text.toString());
    question.answers[0].setText(answer1Controller.text);
    question.answers[1].setText(answer2Controller.text);
    question.answers[2].setText(answer3Controller.text);
    question.answers[3].setText(answer4Controller.text);
    question.setCorrectAnswer(_selectedRadioAnswer.index);
    await question.updateQuestion();
    print("Question edited");
    //print("Question: $questionController.text]");
    notifyListeners();
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
    //notifyListeners();
  }

  /// This method [deleteQuestionFromDatabase] used to delete a question from the database.
  ///
  /// The variable [question] is the question that is going to be deleted.
  deleteQuestionFromDatabase(Question question) async {
    await category.deleteQuestion(question);
    print("Question deleted");
    //print("Question: $questionController.text]");
    notifyListeners();
  }

  /// The method [addCategoryToDatabase] creates a new category and adds it to the database.
  ///
  /// The variable [name] is the name of the category that is going to be created.
  addCategoryToDatabase(String name) async {
    await CategoryRepo().createCategory(name, Colors.blue);
    print("Category added");
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
  }

  /// This method [deleteCategoryFromDatabase] used to delete a category from the database.
  deleteCategoryFromDatabase() async {
    await CategoryRepo().deleteCategory(category.getName());
    print("Category deleted");
    notifyListeners();
  }

  /// The method [createAndStoreRandomQuiz] is used to create a quiz with random questions and
  /// store it in the database.
  ///
  /// It returns a Future<String?> with the id of the quiz that was created.
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
  /// It takes a parameter [questionIds] which is the list of ids of the questions
  /// that are going to be store in the custom quiz.
  ///
  /// It returns a Future<String?>
  /// with the id of the quiz that was created.
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

  void updateIsQuestionChecked({required int index, required bool value}) {
    _isQuestionChecked[index] = value;
    notifyListeners();
  }

  void clearIsQuestionChecked() {
    _isQuestionChecked = List.filled(_questionList.length, false);
    notifyListeners();
  }
}
