/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/view/see_quizzes/see_quizzes_provider.dart';
import 'package:queasy/src/view/see_quizzes/widgets/quiz_list_tile.dart';

class SeeQuizListView extends StatefulWidget {
  const SeeQuizListView({Key? key}) : super(key: key);

  @override
  State<SeeQuizListView> createState() => _SeeQuizListViewState();
}

class _SeeQuizListViewState extends State<SeeQuizListView> {
  bool _isLoading = true;

  init() async {
    // _isLoading = true;
    await Provider.of<SeeQuizzesProvider>(context, listen: false).init();
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
    final provider = Provider.of<SeeQuizzesProvider>(context);
    final quizList = provider.quizList;

    double width = MediaQuery.of(context).size.width;
    TextStyle? headlineTextStyle = theme.textTheme.headline1;
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
                    itemBuilder: (context, index) => QuizListTile(index: index),
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
}
