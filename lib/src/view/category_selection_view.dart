/// ****************************************************************************
/// Created by Nikol Kreshpaj
/// Collaborators: Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/view/play_quiz/quiz_view.dart';
import 'package:queasy/src/view/widgets/side_navigation.dart';
import '../../constants/theme_provider.dart';

/// View for selecting a category.
///
/// This view is used to select a category for the quiz. It displays a progress
/// indicator while the categories are being loaded from the database. When the
/// categories are loaded, it displays a list of categories and when a category
/// is selected, it navigates to [QuizView] with the selected category as a
/// parameter.
class CategorySelectionView extends StatefulWidget {
  CategorySelectionView({Key? key}) : super(key: key);

  @override
  State<CategorySelectionView> createState() => _CategorySelectionViewState();
}

/// State for [CategorySelectionView].
///
/// This state is responsible for updating the view when the user selects a
/// category.
/// The late parameter [list] is used to store the list of categories to be
/// displayed.
/// The parameter [_isLoading] is used to determine whether the view should
/// display a loading indicator or the list of categories.
class _CategorySelectionViewState extends State<CategorySelectionView> {
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

  /// Builds the view.
  ///
  /// Displays a loading indicator while the categories are being loaded from
  /// the database.
  /// Once the categories are loaded, it displays a [ListView] with buttons for
  /// the list of categories returned from the database. When a category is
  /// selected, it navigates to [QuizView] with the selected category as a
  /// parameter.
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return width > 700
        ? Scaffold(
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
                              color: const Color(0xfff1ffe7),
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
                              ),
                              color: const Color(0xffF19C79),
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
                            color: const Color(0xffF19C79),
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
                          width: width / 2.4,
                          height: height / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                            ),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    String categoryName = list[index];
                    return Container(
                      padding:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                      width: 70,
                      height: MediaQuery.of(context).size.height / 8,
                      child: ElevatedButton(
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
                              builder: (context) => QuizView(
                                category: categoryName,
                              ),
                            ),
                          );
                        },
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
                    );
                  },
                ),
                SideNavigation(),
                SizedBox(
                  width: width - SideNavigation.width,
                ),
              ],
            )))
        : Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 40,
            ),
          ),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                String categoryName = list[index];
                return Container(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                  width: 70,
                  height: MediaQuery.of(context).size.height / 8,
                  child: ElevatedButton(
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
                          builder: (context) => QuizView(
                            category: categoryName,
                          ),
                        ),
                      );
                    },
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
                );
              },
            ),
          ],
        ),
      );
    }
  }
