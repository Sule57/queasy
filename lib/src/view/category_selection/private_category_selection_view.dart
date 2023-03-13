/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/model/category_repo.dart';
import '../../../constants/theme_provider.dart';
import '../see_questions/category_questions_provider.dart';
import '../see_questions/category_questions_view.dart';
import '../see_questions/widgets/questions_popups.dart';

/// View for selecting a private category.
///
/// This view is used to select a private category. It displays a progress
/// indicator while the categories are being loaded from the database. When the
/// categories are loaded, it displays a list of private categories and when a category
/// is selected, it navigates to [CategoryQuestionsView] with the selected category as a
/// parameter.
class PrivateCategorySelectionView extends StatefulWidget {
  PrivateCategorySelectionView({Key? key}) : super(key: key);

  @override
  State<PrivateCategorySelectionView> createState() =>
      _PrivateCategorySelectionViewState();
}

/// State for [PrivateCategorySelectionView].
///
/// This state is responsible for updating the view when the user selects a
/// category.
class _PrivateCategorySelectionViewState
    extends State<PrivateCategorySelectionView> {
  /// The provider of the class
  late CategoryQuestionsProvider controller;

  /// Used to store the list of categories to be displayed.
  late List<String> _categoryList;

  /// Used to determine whether the view should display a loading indicator or the list of categories.
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    controller = Provider.of<CategoryQuestionsProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Called when the view is build for the first time, it initializes the
  /// [_categoryList] calling the database and sets [_isLoading] to false once the
  /// data is loaded.
  init() async {
    _isLoading = true;
    _categoryList = await CategoryRepo().getPrivateCategories();
    controller.categoryList = _categoryList;
    await controller.updateListOfCategories();
    _categoryList = context.read<CategoryQuestionsProvider>().categoryList;
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
  /// selected, it navigates to [CategoryQuestionsView] with the selected category as a
  /// parameter.
  @override
  Widget build(BuildContext context) {
    _categoryList = context.watch<CategoryQuestionsProvider>().categoryList;

    /// Widget that is going to be displayed in the screen. If there are no categories, the widget
    /// CategoryListEmpty is assigned, otherwise, the list of categories is displayed (CategoryList).
    late Widget ListWidget;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      _categoryList = context.watch<CategoryQuestionsProvider>().categoryList;
      if (_categoryList.isEmpty) {
        ListWidget = CategoryListEmpty();
      } else {
        ListWidget = CategoryList(list: _categoryList);
      }
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              iconSize: 30,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.add_circle, color: Colors.white54),
                onPressed: () {
                  // Create an alert dialog to add a new category
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewCategoryPopUp();
                      });
                },
                iconSize: 30,
              ),
            ),
          ],
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
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(20)),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                ),
              ),
            ),
            ListWidget,
          ],
        ),
      );
    }
  }
}

/// This widget shows a [Container] with a [Text] widget that says that the user
/// has no private categories yet.
///
/// It is called when no private categories are found in the database.
class CategoryListEmpty extends StatelessWidget {
  const CategoryListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onTertiary,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: size.height / 5,
        width: size.width < 700 ? size.width / 1.4 : size.width / 3,
        alignment: Alignment.center,
        child: Text(
            'You don\'t have any categories yet...\nWhy don\'t you create one?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}

/// This widget is used to display a [ListView] with all the private categories
/// of the user.
///
/// It is called when private categories are found in the database.
class CategoryList extends StatefulWidget {
  /// List of private categories.
  List<String> list;

  CategoryList({Key? key, required this.list}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  get list => widget.list;

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryQuestionsProvider>(
        builder: (context, controller, child) {
      return ListView.builder(
        itemCount: controller.categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          String categoryName = controller.categoryList[index];
          return Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CategoryQuestionsView(categoryName: categoryName)));
              },
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .colorScheme
                      .onBackground,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
