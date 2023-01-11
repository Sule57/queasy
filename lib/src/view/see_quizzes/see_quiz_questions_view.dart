/// ****************************************************************************
/// Created by Julia Agüero
/// Collaborators: Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';

class SeeQuizQuestionsView extends StatelessWidget {
  final String quizId;
  final String quizName;

  const SeeQuizQuestionsView({
    Key? key,
    required this.quizId,
    required this.quizName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quizName),
      ),
      body: Container(),
    );
  }
}
