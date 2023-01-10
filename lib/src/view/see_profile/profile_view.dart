import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/see_profile/profile_view_desktop.dart';
import 'package:queasy/src/view/see_profile/profile_view_mobile.dart';

import 'profile_provider.dart';

/// Content for [ProfileView].
///
/// Uses a [StatefulWidget] to display questions and answers and update the
/// text contained in the widgets.
class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, this.category, this.id}) : super(key: key);

  final String? category;
  final String? id;

  /// Creates a [ProfileView] state.
  @override
  State<ProfileView> createState() => _ProfileViewContentState();
}

/// State for [ProfileViewContent].
class _ProfileViewContentState extends State<ProfileView> {
  bool isLoading = true;

  init() async {
    isLoading = !(await Provider.of<ProfileProvider>(context, listen: false)
        .setProfile());
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

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
