import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spider_chart/spider_chart.dart';

import '../profile_provider.dart';

/// The widget [StatisticsGraph] is used to display user's statistic information.
/// Get its data from the [ProfileProvider].
class StatisticsGraph extends StatelessWidget {
  /// Builds the [StatisticsGraph] Widget.
  @override
  Widget build(BuildContext context) {
    final List<double> data =
        Provider.of<ProfileProvider>(context).getGraphData();

    var maximumNumber =
        data.reduce((value, element) => value > element ? value : element);

    List<String> keys = Provider.of<ProfileProvider>(context).getGraphKeys();

    List<Color> getColorData() {
      List<Color> color = [];
      color.add(Color(0xff72479d));
      int i = data.length;
      while (i != 1) {
        color.add(Color(0xff72479d));
        i = i - 1;
      }
      return color;
    }

    final List<Color> color = getColorData();

    return SizedBox(
      height: 200,
      child: Center(
        child: SpiderChart(
          data: data,
          labels: keys,
          maxValue:
              maximumNumber, // the maximum value that you want to represent (essentially sets the data scale of the chart)
          size: Size(keys.length * 50, 450),
          fallbackHeight: 200,
          fallbackWidth: 200,
          decimalPrecision: 0,
          colors: color,
        ),
      ),
    );
  }
}
