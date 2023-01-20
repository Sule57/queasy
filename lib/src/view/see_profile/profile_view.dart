/// ****************************************************************************
/// Created by Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/see_profile/profile_view_desktop.dart';
import 'package:queasy/src/view/see_profile/profile_view_mobile.dart';

import '../statistics/statistics_provider.dart';
import 'profile_provider.dart';

/// Content for [ProfileView].
///
/// Uses a [StatefulWidget] to display questions and answers and update the
/// text contained in the widgets.
class ProfileView extends StatefulWidget {
  const ProfileView({
    Key? key,
  }) : super(key: key);

  /// Creates a [ProfileView] state.
  @override
  State<ProfileView> createState() => _ProfileViewContentState();
}

/// State for [ProfileViewContent].
class _ProfileViewContentState extends State<ProfileView> {
  /// Used to determine whether the view should display a loading indicator.
  bool isLoading = true;

  /// Called when the view is build for the first time.
  /// It sets [isLoading] to false once the
  /// data is loaded from the [ProfileProvider] is loaded
  /// and waits for [StatisticsProvider] to initialize.
  init() async {
    isLoading = !(await Provider.of<ProfileProvider>(context, listen: false)
        .setProfile());
    await Provider.of<StatisticsProvider>(context, listen: false)
        .initStatisticsProvider();
    setState(() {});
  }

  /// Initializes the view.
  ///
  /// Calls [init] to initialize the view.
  @override
  void initState() {
    init();
    super.initState();
  }

  /// Called when the view is disposed.
  @override
  void dispose() {
    super.dispose();
  }

  /// Builds the content depending on the screen size, with a threshold of 700
  /// pixels. If the screen is smaller than 700 pixels, the function displays
  /// [ProfileViewMobileContent]. Otherwise, it displays [ProfileViewDesktopContent].
  /// It also displays a [CircularProgressIndicator] while the profile data is loading.
  /// When the profile data is loaded, the [CircularProgressIndicator] is replaced by
  /// the content.
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : MediaQuery.of(context).size.width > 700
            ? ProfileViewDesktop()
            : ProfileViewMobile();
  }
}
