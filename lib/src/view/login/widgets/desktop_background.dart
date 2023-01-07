import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/theme_provider.dart';

class DesktopBackground extends StatelessWidget {
  const DesktopBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context).currentTheme;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            height: height / 1.7,
            width: width / 5.5,
            decoration: BoxDecoration(
              color: themeProvider.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: height * .25,
              width: width / 2.1,
              decoration: BoxDecoration(
                  color: themeProvider.colorScheme.tertiary,
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(20))),
            ),
          ),
          Positioned(
            left: 0,
            bottom: height / 5.4,
            child: Container(
              height: height * .35,
              width: width / 10,
              decoration: BoxDecoration(
                color: themeProvider.colorScheme.onTertiary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: height / 4.5,
              width: width / 4,
              decoration: BoxDecoration(
                color: themeProvider.colorScheme.onTertiary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
