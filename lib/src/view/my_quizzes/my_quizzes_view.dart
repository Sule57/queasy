/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/view/my_quizzes/widgets/quiz_list_tile.dart';

/// Displays the list of quizzes of the current user.
///
/// It uses a [ListView] to display the list of quizzes. It contains a stack
/// with [MyQuizzesBackground] and [MyQuizzesContent].
class MyQuizzesView extends StatefulWidget {
  /// Constructor for the [MyQuizzesView].
  const MyQuizzesView({Key? key}) : super(key: key);

  /// Creates the state for this widget.
  @override
  State<MyQuizzesView> createState() => _MyQuizzesViewState();
}

/// State for the [MyQuizzesView].
class _MyQuizzesViewState extends State<MyQuizzesView> {
  /// Builds the view.
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    TextStyle? headlineTextStyle = theme.textTheme.headline1;

    return Scaffold(
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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MyQuizzesBackground(),
          MyQuizzesContent(),
        ],
      ),
    );
  }
}

class MyQuizzesBackground extends StatelessWidget {
  const MyQuizzesBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    double width = MediaQuery.of(context).size.width;
    double heigth = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: heigth,
      color: theme.colorScheme.secondary,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: width / 2.5,
              height: heigth / 2,
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(20)),
              ),
            ),
          ),
          Positioned(
            left: width / 15,
            bottom: heigth / 3,
            child: Container(
              width: width * 0.6,
              height: heigth / 3,
              decoration: BoxDecoration(
                color: theme.colorScheme.onTertiary,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: width * 0.8,
              height: heigth / 4.3,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyQuizzesContent extends StatefulWidget {
  const MyQuizzesContent({Key? key}) : super(key: key);

  @override
  State<MyQuizzesContent> createState() => _MyQuizzesContentState();
}

class _MyQuizzesContentState extends State<MyQuizzesContent> {
  bool _isLoading = true;

  init() async {
    // _isLoading = true;
    await Provider.of<MyQuizzesProvider>(context, listen: false)
        .updateQuizList();
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
    final provider = Provider.of<MyQuizzesProvider>(context);
    final quizList = provider.quizList;

    double width = MediaQuery.of(context).size.width;
    TextStyle? bodyTextStyle = theme.textTheme.subtitle1;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : quizList.length > 0
            ? ListView.builder(
                itemCount: quizList.length,
                itemBuilder: (context, index) => QuizListTile(index: index),
              )
            : Center(
                child: Container(
                  width: width / 2,
                  padding: EdgeInsets.all(20),
                  child: Text('Seems like you haven\'t added a quiz yet',
                      textAlign: TextAlign.center, style: bodyTextStyle),
                ),
              );
  }
}
