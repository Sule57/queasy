/// ****************************************************************************
/// Created by Julia Agüero
/// Collaborators: Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src.dart';

class SeeQuizQuestionsView extends StatefulWidget {
  final String quizId;
  final String quizName;

  const SeeQuizQuestionsView({
    Key? key,
    required this.quizId,
    required this.quizName,
  }) : super(key: key);

  @override
  State<SeeQuizQuestionsView> createState() => _SeeQuizQuestionsViewState();
}

class _SeeQuizQuestionsViewState extends State<SeeQuizQuestionsView> {
  get quizId => widget.quizId;
  get quizName => widget.quizName;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final provider = Provider.of<SeeQuizzesProvider>(context);
    TextStyle? headlineTextStyle = theme.textTheme.headline3;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quizName,
          style: headlineTextStyle,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 10, left: 16.0, right: 16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Delete quiz'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          provider.deleteQuiz(quizId);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
