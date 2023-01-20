/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:queasy/src.dart';

/// Provider for the view [MyQuizzesView].
///
/// It carries out the communication between the view and the model. It is used
/// to get the list of quizzes of the current user and to update the data of the
/// quiz that is being displayed. It also has a function to delete a quiz.
class MyQuizzesProvider with ChangeNotifier {
  /// List of quizzes of the current user.
  List<Quiz> quizList = [];

  /// List of questions of the quiz that is being displayed.
  List<Question> _questionList = [];

  /// Getter for the list of questions of the quiz that is being displayed.
  List<Question> get questionList => _questionList;

  /// [Quiz] that is being displayed.
  late Quiz quizDisplaying;

  /// Updates [quizList] with the list of quizzes of the current user. It is
  /// called when the state is initialized.
  Future<void> updateQuizList() async {
    quizList = await Profile.getUserQuizzes();
    notifyListeners();
  }

  /// Updates the data of [quizDisplaying]. It is called when the user selects a
  /// quiz to display its questions and is taken to [QuizQuestionsView].
  Future<void> updateCurrentQuizDisplaying(String quizId) async {
    quizDisplaying = await Quiz().retrieveQuizFromId(id: quizId);
    notifyListeners();
  }

  ///Deletes the quiz with the given [id] from the database.
  Future<void> deleteQuiz(String id) async {
    await Category.deleteQuiz(id: id);
    updateQuizList();
  }
}
