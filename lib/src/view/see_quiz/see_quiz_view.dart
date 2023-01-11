/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/view/see_quiz/see_quiz_provider.dart';
import 'package:queasy/src/view/see_quiz/widgets/share_popup.dart';

import '../edit_quiz/edit_quiz_view.dart';

class SeeQuizView extends StatefulWidget {
  const SeeQuizView({Key? key}) : super(key: key);

  @override
  State<SeeQuizView> createState() => _SeeQuizViewState();
}

class _SeeQuizViewState extends State<SeeQuizView> {
  bool _isLoading = true;

  init() async {
    _isLoading = true;
    await Provider.of<SeeQuizProvider>(context, listen: false).init();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final provider = Provider.of<SeeQuizProvider>(context);
    final quizList = provider.quizList;

    double width = MediaQuery.of(context).size.width;
    TextStyle? headlineTextStyle = theme.textTheme.headline1;
    TextStyle? quizNameTextStyle = theme.textTheme.headline4;
    TextStyle? categoryNameTextStyle = theme.textTheme.subtitle2;
    TextStyle? bodyTextStyle = theme.textTheme.subtitle1;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'My quizzes',
                style: headlineTextStyle,
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
              //actions: add quiz
            ),
            body: quizList.length > 0
                ? ListView.builder(
                    itemCount: quizList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 2.0,
                            ),
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
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => EditQuizView(
                              //       quizId: provider.quizList[index].id,
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Container(
                      width: width / 2,
                      padding: EdgeInsets.all(20),
                      child: Text('Seems like you didn\'t add a quizz yet',
                          textAlign: TextAlign.center, style: bodyTextStyle),
                    ),
                  ),
          );
  }

  //shows a popup menu with listTiles with the following elements: share, edit and
  void _showPopupMenu(
      {required BuildContext context,
      required TapDownDetails details,
      required String quizId}) {
    SeeQuizProvider provider =
        Provider.of<SeeQuizProvider>(context, listen: false);
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
            leading: const Icon(Icons.edit),
            title: Text(
              'Edit',
              style: bodyTextStyle,
            ),
            // TODO: edit quiz
            // onTap: () {
            //   Navigator.of(context).pop();
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => EditQuizView(
            //         quizId: quizId,
            //       ),
            //     ),
            //   );
            // },
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
