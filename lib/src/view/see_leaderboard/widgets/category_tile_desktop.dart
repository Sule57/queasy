/// ****************************************************************************
/// Created by Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/see_leaderboard/leaderboard_provider.dart';

/// The widget [CategoryTileDesktop] is used to show one category tile for the desktop view.
/// It also allows for toggling the shown category.
/// A String [title] and List<String> [entries] are required for construction.
class CategoryTileDesktop extends StatelessWidget {
  ///[title] stores the category name
  final String title;

  ///[entries] stores the 10 entries in the leaderboard for the given category
  final List<String> entries;

  const CategoryTileDesktop(
      {super.key, required this.title, required this.entries});

  /// Builds the [CategoryTileDesktop] Widget.
  ///
  /// On tap, the [Container] calls he [LeaderboardProvider] to update which category
  /// data is shown on the view.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
