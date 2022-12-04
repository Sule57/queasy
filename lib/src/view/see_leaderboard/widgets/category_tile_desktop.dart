import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/see_leaderboard/leaderboard_provider.dart';

class CategoryTileDesktop extends StatelessWidget {
  final String title;
  final List<String> entries;

  const CategoryTileDesktop(
      {super.key, required this.title, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // const Divider(
        //   height: 20,
        // ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFF1FFE7),
          ),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            textColor: Colors.black,
            title: Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 26),
            ),
            onTap: () {
              Provider.of<LeaderboardProvider>(context, listen: false)
                  .setLeaderboard(title);
            },
          ),
        ),
      ],
    );
  }
}
