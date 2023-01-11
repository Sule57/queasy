/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:queasy/src.dart';

class SeeQuizzesProvider with ChangeNotifier {
  List<Quiz> quizList = [];
  List<Question> _questionList = [];
  List<Question> get questionList => _questionList;

  ///Obtains from Firestore all the quizzes that the current logged in user
  ///has stored. It is run when [SeeQuizListView] is initialized.
  Future<void> init() async {
    quizList = await Profile.getUserQuizzes();
    notifyListeners();
  }

  ///Deletes the quiz with the given [id] from the database.
  Future<void> deleteQuiz(String id) async {
    //TODO
    await Category.deleteQuiz(id: id);
    notifyListeners();
  }
}
