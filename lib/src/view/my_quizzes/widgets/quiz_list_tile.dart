/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/view/my_quizzes/quiz_questions_view.dart';

/// Widget used in the view [MyQuizzesView] as child of the [ListView.builder].
/// It shows the title of the quiz, the category, and an option menu to delete
/// or share the quiz.
///
/// It takes the [index] as a parameter when it is created, that is used to get
/// the quiz from the list of quizzes in the [MyQuizzesProvider].
class QuizListTile extends StatelessWidget {
  /// Index of the quiz in the list of quizzes in the [MyQuizzesProvider].
  final int index;

  /// Constructor for the [QuizListTile].
  const QuizListTile({Key? key, required this.index}) : super(key: key);

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final provider = Provider.of<MyQuizzesProvider>(context);
    final quizList = provider.quizList;

    TextStyle? quizNameTextStyle = theme.textTheme.headline4;
    TextStyle? categoryNameTextStyle = theme.textTheme.subtitle2;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            title: Text(
              quizList[index].name!,
              style: quizNameTextStyle,
            ),
            subtitle: Text(
              quizList[index].category.name!,
              style: categoryNameTextStyle,
            ),
            trailing: GestureDetector(
              child: Icon(Icons.more_vert),
              onTapDown: (details) => _showPopupMenu(
                context: context,
                details: details,
                quizId: quizList[index].id,
              ),
            ),
            onTap: () {
              print(quizList[index].id);
              print(quizList[index].name);
              print(quizList[index].ownerID);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizQuestionsView(
                    quizId: quizList[index].id,
                  ),
                ),
              );
            }),
      ),
    );
  }

  /// Shows a popup menu with the options to delete or share the quiz. It takes
  /// the [context], the [details] of the tap, and the [quizId] as parameters.
  /// The menu is shown at the position of the tap using the [details].
  void _showPopupMenu(
      {required BuildContext context,
      required TapDownDetails details,
      required String quizId}) {
    MyQuizzesProvider provider =
        Provider.of<MyQuizzesProvider>(context, listen: false);
    TextStyle? bodyTextStyle =
        Provider.of<ThemeProvider>(context, listen: false)
            .currentTheme
            .textTheme
            .subtitle2;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        0,
        0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.share),
            title: Text(
              'Share',
              style: bodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (context) => ShareDialog(quizId: quizId));
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete),
            title: Text(
              'Delete',
              style: bodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
              provider.deleteQuiz(quizId);
              Future.delayed(Duration.zero, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Quiz deleted'),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
