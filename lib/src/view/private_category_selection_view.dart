/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/model/category_repo.dart';
import '../../constants/theme_provider.dart';
import 'edit_quiz/edit_quiz_view.dart';

/// View for selecting a private category.
///
/// This view is used to select a private category. It displays a progress
/// indicator while the categories are being loaded from the database. When the
/// categories are loaded, it displays a list of private categories and when a category
/// is selected, it navigates to [EditQuizView] with the selected category as a
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
/// The late parameter [list] is used to store the list of categories to be
/// displayed.
/// The parameter [_isLoading] is used to determine whether the view should
/// display a loading indicator or the list of categories.
class _PrivateCategorySelectionViewState
    extends State<PrivateCategorySelectionView> {
  late List<String> list;
  bool _isLoading = true;

  /// Called when the view is build for the first time, it initializes the
  /// [list] calling the database and sets [_isLoading] to false once the
  /// data is loaded.
  init() async {
    _isLoading = true;
    list = await CategoryRepo().getPrivateCategories();
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
  /// selected, it navigates to [EditQuizView] with the selected category as a
  /// parameter.
  @override
  Widget build(BuildContext context) {
    late Widget ListWidget;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (list.isEmpty) {
        ListWidget = CategoryListEmpty();
      } else {
        ListWidget = CategoryList(list: list);
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
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              onPressed: () => Navigator.pop(context),
              iconSize: 30,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.add_circle,
                    color: Theme.of(context).colorScheme.onTertiary),
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
            ListWidget,
          ],
        ),
      );
    }
  }
}

/// This widget is used to display an [AlertDialog] to add a new category.
class NewCategoryPopUp extends StatefulWidget {
  const NewCategoryPopUp({
    Key? key,
  }) : super(key: key);

  @override
  State<NewCategoryPopUp> createState() => _NewCategoryPopUpState();
}

class _NewCategoryPopUpState extends State<NewCategoryPopUp> {
  final TextEditingController newCategoryController = TextEditingController();

  @override
  void dispose() {
    newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add a new category',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      content: TextField(
        controller: newCategoryController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Category name',
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            TextButton(
              onPressed: () async {
                // Check if the entered text is empty of filled with spaces
                if (newCategoryController.text.trim().isEmpty) {
                  // Show an alert dialog to inform the user that the category
                  // name cannot be empty
                  Future.delayed(Duration.zero, () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text('Category name cannot be empty'),
                        );
                      },
                    );
                  });
                } else {
                  // Add the new category to the database
                  await CategoryRepo()
                      .createCategory(newCategoryController.text, Colors.blue);
                  Navigator.pop(context); // Close the alert dialog
                  // Refresh the view
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivateCategorySelectionView(),
                    ),
                  );
                  print('Category added');
                }
              },
              child: Text('Confirm'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
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
///
/// The variable [list] is the list of private categories.
class CategoryList extends StatefulWidget {
  List<String> list;

  CategoryList({Key? key, required this.list}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  get list => widget.list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        String categoryName = list[index];
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
                          EditQuizView(categoryName: categoryName)));
            },
            child: Text(
              categoryName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
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
  }
}
