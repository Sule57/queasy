/// ****************************************************************************
/// Created by Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:flutter/material.dart';
import 'category_selection_view_desktop.dart';
import 'category_selection_view_mobile.dart';

///This is Category Selection View
///It displays Mobile or Desktop versions of Category Selection View depending on width of the screen
class CategorySelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///if width of the device is less than 700 then CategorySelectionMobile is shown
    ///if more than 700 then the user sees CategorySelectionDesktop
    return MediaQuery.of(context).size.width > 700
        ? CategorySelectionViewDesktop()
        : CategorySelectionViewMobile();
  }
}
