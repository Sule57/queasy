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

class QuizListTile extends StatelessWidget {
  final int index;

  const QuizListTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final provider = Provider.of<SeeQuizzesProvider>(context);
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

  //shows a popup menu with listTiles with the following elements: share, edit and
  void _showPopupMenu(
      {required BuildContext context,
      required TapDownDetails details,
      required String quizId}) {
    SeeQuizzesProvider provider =
        Provider.of<SeeQuizzesProvider>(context, listen: false);
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
