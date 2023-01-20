/// ****************************************************************************
/// Created by Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:flutter/material.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/model/leaderboard_entry.dart';

import '../../model/leaderboard.dart';

/// This class is responsible for managing the data on the leaderboard view.
///
/// The late field [_currentLeaderboard] stores the current [Leaderboard].
///
/// The late field [_entries] stores the entries in the [_currentLeaderboard].
///
/// The late field [_publicCategories] stores all possible category names.
///
/// The field [_totalEntries] stores the number of entries in the [Leaderboard] This value can be between 0 and 10.
///
/// The field [_category] stores the current category name. It is initialized as 'All'.
class LeaderboardProvider with ChangeNotifier {
  late Leaderboard _currentLeaderboard;
  late List<LeaderboardEntry> _entries;
  late List<String> _publicCategories = [];
  int _totalEntries = 0;
  String _category = 'All';

  ///getter methods for leaderboard data
  get totalEntries => _totalEntries;
  get category => _category;
  get entries => _entries;
  get publicCategories => _publicCategories;

  ///Constructor that calls [initLeaderboardProvider].
  LeaderboardProvider() {
    initLeaderboardProvider();
  }

  ///Sets the late fields in the [LeaderboardProvider].
  ///It awaits information from the [Leaderboard] class and the [CategoryRepo].
  ///It also notifies listeners.
  void initLeaderboardProvider() async {
    _currentLeaderboard = await Leaderboard.createPublic(_category, '');
    _entries = _currentLeaderboard.getEntries();
    _totalEntries = _entries.length;
    _publicCategories = await CategoryRepo().getPublicCategories();
    _publicCategories.add('All');
    notifyListeners();
  }

  ///Sets fields in the [LeaderboardProvider].
  ///It awaits information from the [Leaderboard] class given a new [category].
  ///It also notifies listeners.
  void setLeaderboard(String category) async {
    _currentLeaderboard = await Leaderboard.createPublic(category, '');
    _entries = _currentLeaderboard.getEntries();
    _totalEntries = _entries.length;
    _category = category;
    notifyListeners();
  }

  ///Sets the [_publicCategories] field in the [LeaderboardProvider].
  ///It awaits information from the [CategoryRepo].
  ///It also notifies listeners.
  void setCategories() async {
    _publicCategories = await CategoryRepo().getPublicCategories();
    _publicCategories.add('All');
    notifyListeners();
  }
}
