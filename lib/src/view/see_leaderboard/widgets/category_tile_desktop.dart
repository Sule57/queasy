import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';

class CategoryTileDesktop extends StatelessWidget {
  final String title;

  const CategoryTileDesktop({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Divider(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            tileColor: Theme.of(context).colorScheme.tertiary,
            textColor: Colors.black,
            iconColor: Colors.white,
            title: Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 26),
            ),
            //const Icon(Icons.back_hand_outlined),
            //subtitle: index == 0 ? const Text('username', textAlign: TextAlign.center,style:TextStyle(color: Colors.black, fontSize: 26),): null,
          ),
        ),
      ],
    );
  }
}
