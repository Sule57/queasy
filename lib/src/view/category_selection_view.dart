import 'package:flutter/material.dart';

/// This is the widget responsible for building the item in the list,
/// once we have the actual data [item].

class CategorySelectionView extends StatelessWidget {
  CategorySelectionView({Key? key}) : super(key: key);

  final List<String> list = <String>[
    'All',
    'Sports',
    'History',
    'Art',
    '...',
    '...',
    '...',
    '...',
  ];

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
            iconSize: 40,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            width: 70,
            height: MediaQuery.of(context).size.height / 8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: Center(
                  child: Text(
                ('${list[index]}'),
                style: Theme.of(context).textTheme.headline3,
              )),
            ),
          );
        },
      ),
    );
  }
}
