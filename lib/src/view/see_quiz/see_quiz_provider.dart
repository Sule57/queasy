/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:queasy/src.dart';

class SeeQuizProvider with ChangeNotifier {
  late List<Quiz> quizList;

  ///Obtains from Firestore all the quizzes that the current logged in user
  ///has stored. It is run when [SeeQuizView] is initialized.
  Future<void> init() async {
    //TODO: get quiz list from model
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
