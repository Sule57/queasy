import 'package:flutter/material.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/model/leaderboard_entry.dart';

import '../../model/leaderboard.dart';

///This is controller for LeaderboardView
class LeaderboardProvider with ChangeNotifier {
  ///This is the current leaderboard
  late Leaderboard _currentLeaderboard;

  ///This is the list of all the entries of the current leaderboard
  late List<LeaderboardEntry> _entries;

  ///This is the list of all the categories
  late List<String> _publicCategories = [];

  ///Number of entries
  int _totalEntries = 0;

  ///This is the current category. Default is "All"
  String _category = 'All';

  get totalEntries => _totalEntries;
  get category => _category;
  get entries => _entries;
  get publicCategories => _publicCategories;

  ///constructor
  LeaderboardProvider() {
    initLeaderboardProvider();
  }

  ///This function initializes the leaderboard provider
  void initLeaderboardProvider() async {
    _currentLeaderboard = await Leaderboard.createPublic(_category, '');
    _entries = _currentLeaderboard.getEntries();
    _totalEntries = _entries.length;
    _publicCategories = await CategoryRepo().getPublicCategories();
    _publicCategories.add('All');
    notifyListeners();
  }

  ///This function sets the current leaderboard
  void setLeaderboard(String category) async {
    _currentLeaderboard = await Leaderboard.createPublic(category, '');
    _entries = _currentLeaderboard.getEntries();
    _totalEntries = _entries.length;
    _category = category;
    notifyListeners();
  }

  ///This function returns the categories
  void setCategories() async {
    _publicCategories = await CategoryRepo().getPublicCategories();
    _publicCategories.add('All');
    notifyListeners();
  }
}
