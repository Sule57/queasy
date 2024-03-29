/// ****************************************************************************
/// Created by Nikol Kreshpaj
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/widgets/side_navigation.dart';
import '../../../src.dart';

///This is Category Selection view
///
///It displays web version of the category selection page. It is the view where the user
///can see all the categories available to play a quiz. Upon selection of the category
///the user is taken to [QuizView].
class CategorySelectionViewDesktop extends StatefulWidget {
  CategorySelectionViewDesktop({Key? key}) : super(key: key);

  ///creates UserProfileDesktop class
  @override
  State<CategorySelectionViewDesktop> createState() =>
      CategorySelectionDesktopState();
}

///State for [CategorySelectionViewDesktop].
class CategorySelectionDesktopState
    extends State<CategorySelectionViewDesktop> {
  /// Builds the view.
  ///
  /// Uses a [Stack] to display the
  /// [CategorySelectionDesktopViewBackground] and the [CategorySelectionDesktopViewContent] on top.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CategorySelectionDesktopViewBackground(),
          CategorySelectionDesktopViewContent(),
        ],
      ),
    );
  }
}

/// Background for [CategorySelectionDesktopView].
///
/// Uses a [StatelessWidget] to display a background color.
class CategorySelectionDesktopViewBackground extends StatelessWidget {
  /// Constructor for [CategorySelectionDesktopViewBackground].
  const CategorySelectionDesktopViewBackground({Key? key}) : super(key: key);

  /// Builds the background.
  ///
  /// It shows a container of size one third of the screen and with the main
  /// color of [AppThemes].
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var theme = Provider.of<ThemeProvider>(context).currentTheme!;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: Align(
                  alignment: FractionalOffset.topLeft,
                  child: Container(
                    width: width / 1.5,
                    height: height / 4,
                    //alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onTertiary,
                    ),
                  ),
                ))
              ],
            ),
            Column(
              children: [
                Expanded(
                    child: Align(
                  alignment: FractionalOffset.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(top: 130),
                    width: width / 3,
                    height: height / 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ))
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Container(
                      width: width / 7,
                      height: height / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                        ),
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Container(
                      width: width / 2.5,
                      height: height / 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                        ),
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Content for [CategorySelectionViewDesktop].
///
/// Uses a [StatefulWidget] to display questions and answers and update the
/// text contained in the widgets.
class CategorySelectionDesktopViewContent extends StatefulWidget {
  const CategorySelectionDesktopViewContent({Key? key}) : super(key: key);

  /// Creates a [CategorySelectionDesktopViewContent] state.
  @override
  State<CategorySelectionDesktopViewContent> createState() =>
      _CategorySelectionDesktopViewContentState();
}

/// State for [QuizViewContent]
class _CategorySelectionDesktopViewContentState
    extends State<CategorySelectionDesktopViewContent> {
  late List<String> list;
  bool _isLoading = true;

  /// Called when the view is build for the first time, it initializes the
  /// [list] calling the database and sets [_isLoading] to false once the
  /// data is loaded.
  init() async {
    _isLoading = true;
    list = await CategoryRepo().getPublicCategories();
    setState(() {
      _isLoading = false;
    });
  }

  /// Initializes the view.
  ///
  /// Calls [init] to initialize the view.
  @override
  void initState() {
    init();
    super.initState();
  }

  /// Builds the content.
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideNavigation(),
            Container(
              width: MediaQuery.of(context).size.width - SideNavigation.width,
              padding: EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 420,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: 4 / 2),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  String categoryName = list[index];
                  return Container(
                    // width: 200,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Provider.of<ThemeProvider>(context)
                                .currentTheme
                                .colorScheme
                                .background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlayQuizView(
                                  category: categoryName,
                                ),
                              ),
                            );
                          },
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              categoryName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                color: Provider.of<ThemeProvider>(context)
                                    .currentTheme
                                    .colorScheme
                                    .onBackground,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        )),
      );
    }
  }
}
