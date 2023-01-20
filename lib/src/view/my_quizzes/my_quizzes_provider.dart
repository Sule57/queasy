/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:queasy/src.dart';

class MyQuizzesProvider with ChangeNotifier {
  List<Quiz> quizList = [];
  List<Question> _questionList = [];
  List<Question> get questionList => _questionList;

  // String currentQuizId = '';
  // String currentQuizName = '';
  late Quiz quizDisplaying;

  Future<void> updateQuizList() async {
    quizList = await Profile.getUserQuizzes();
    notifyListeners();
  }

  Future<void> updateCurrentQuizDisplaying(String quizId) async {
    quizDisplaying = await Quiz().retrieveQuizFromId(id: quizId);
    notifyListeners();
  }

  ///Deletes the quiz with the given [id] from the database.
  Future<void> deleteQuiz(String id) async {
    //TODO
    await Category.deleteQuiz(id: id);
    updateQuizList();
  }
}
