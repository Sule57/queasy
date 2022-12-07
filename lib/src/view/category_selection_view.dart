import 'package:flutter/material.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/view/play_quiz/quiz_view.dart';

/// This is the widget responsible for building the item in the list,
/// once we have the actual data [item].

class CategorySelectionView extends StatefulWidget {
  CategorySelectionView({Key? key}) : super(key: key);

  @override
  State<CategorySelectionView> createState() => _CategorySelectionViewState();
}

class _CategorySelectionViewState extends State<CategorySelectionView> {
  late List<String> list;
  bool _isLoading = true;

  init() async {
    _isLoading = true;
    list = await CategoryRepo().getPublicCategories();
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
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
        body: ListView.builder(
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
                  backgroundColor: Colors.white,
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
                child: Center(
                    child: Text(
                  categoryName,
                  style: Theme.of(context).textTheme.headline3,
                )),
              ),
            );
          },
        ),
      );
    }
  }
}
