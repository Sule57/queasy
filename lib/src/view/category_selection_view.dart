import 'package:flutter/material.dart';
import 'category_selection_view_desktop.dart';
import 'category_selection_view_mobile.dart';

///This is Profile View
///It displays Mobile or Desktop versions of Profile View depending on width of the screen
class CategorySelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///if width of the device is less than 700 then UserProfileMobile is shown
    ///if more than 700 then the user sees UserProfileDesktop
    return MediaQuery.of(context).size.width > 700
        ? CategorySelectionViewDesktop()
        : CategorySelectionViewMobile();
  }
}