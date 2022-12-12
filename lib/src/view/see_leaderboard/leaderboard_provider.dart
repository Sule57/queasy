import 'package:flutter/material.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/model/leaderboard_entry.dart';

import '../../model/leaderboard.dart';

class LeaderboardProvider with ChangeNotifier {
  late Leaderboard _currentLeaderboard;
  late List<LeaderboardEntry> _entries;
  late List<String> _publicCategories = [];
  int _totalEntries = 0;
  String _category = 'All';

  get totalEntries => _totalEntries;
  get category => _category;
  get entries => _entries;
  get publicCategories => _publicCategories;

  LeaderboardProvider() {
    initLeaderboardProvider();
  }

  void initLeaderboardProvider() async {
    _currentLeaderboard = await Leaderboard.create(_category, '');
    _entries = _currentLeaderboard.getEntries();
    _totalEntries = _entries.length;
    _publicCategories = await CategoryRepo().getPublicCategories();
    notifyListeners();
  }

  void setLeaderboard(String category) async {
    _currentLeaderboard = await Leaderboard.create(category, '');
    _entries = _currentLeaderboard.getEntries();
    _totalEntries = _entries.length;
    _category = category;
    notifyListeners();
  }

  void setCategories() async {
    _publicCategories = await CategoryRepo().getPublicCategories();
    notifyListeners();
  }
}
