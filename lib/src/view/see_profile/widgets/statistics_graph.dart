import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/app_themes.dart';

import '../../../../constants/theme_provider.dart';
import '../profile_provider.dart';

class StatisticsGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    ///[features] is to store data used for line graph. Scores must be represented as decimals (eg. 3 points = 0.3).
    final List<Feature> features = [
      Feature(
        title: "Public Quizzes",
        color: purple,
        data: Provider.of<ProfileProvider>(context).getGraphData(),
      ),
    ];
    List<String> keys = Provider.of<ProfileProvider>(context).getGraphKeys();

    return SizedBox(
      height: 500,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          LineGraph(
            features: features,
            size: Size(keys.length * 150, 450),
            labelX: keys,
            labelY: ['200', '400', '600', '800', '1000'],
            showDescription: true,
            fontFamily: GoogleFonts.nunito().fontFamily,
            graphColor: Provider.of<ThemeProvider>(context)
                .currentTheme
                .colorScheme
                .onBackground,
          )
        ],
      ),
    );
  }
}
