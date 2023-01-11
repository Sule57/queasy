import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:queasy/src.dart';

/// This is the Model class for the Leaderboard
///
/// It is responsible for connecting the [Leaderboard] to the [LeaderboardEntry]s
/// in the database. It also contains the logic for updating the leaderboard in the database.
class Leaderboard {
  /// Represents a list of all the [LeaderboardEntry]s in the database.
  late List<LeaderboardEntry> _entries = [];

  /// Represents the name of the category that the leaderboard is for.
  late String _category;

  /// Represents the Player that is currently logged in and is playing the game.
  late LeaderboardEntry _currentPlayer;

  /// Represents a boolean that is true if the leaderboard is public and false if it is private.
  late final bool _isPublic;

  /// Represents the UID of the current user.
  late String? UID;

  /// Represents the instance of the [FirebaseFirestore] database.
  late var _firebaseFirestore;

  /// Represents the collection in the database that the leaderboard is stored in.
  late CollectionReference _collection = _firebaseFirestore.collection('leaderboard');

  /// Represents the document in the database that the leaderboard is stored in for public leaderboards.
  late DocumentReference _doc = _collection.doc(_category);

  /// Represents the document in the database that the leaderboard is stored in for combined All leaderboard.
  late DocumentReference _docAll = _collection.doc('All');


  /// Private constructor for [Leaderboard] that deals with initializing the private parameters.
  ///
  /// [category] is the name of the category that the leaderboard is for. [username] is the username of the current user playing.
  /// [isPublic] is a boolean that is true if the leaderboard is public and false if it is private.
  /// [firestore] is the instance of the Firestore database. If it is passed,
  /// the constructor assumes that the developer is in testing and will
  /// initialize the [UID] with a default value and [_collection], [_doc] and [_docAll] with the references in the test database.
  Leaderboard._create(String category, String username, bool isPublic, {FirebaseFirestore? instance, String? id}) {
    _entries = [];
    _currentPlayer = LeaderboardEntry(username, 0, -1);
    _category = category;
    this._isPublic = isPublic;

    if(instance == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
      UID = getCurrentUserID();
    }else{
      if(id == null) {
        throw Exception('ID cannot be null if instance is not null');
      }
      UID = id;
      this._firebaseFirestore = instance;
      _collection = _firebaseFirestore.collection('leaderboard');
      _doc = _collection.doc(_category);
      _docAll = _collection.doc('All');
    }
  }

  /// Public factory constructor for public [Leaderboard] that creates a new [Leaderboard] object.
  ///
  /// [category] is the name of the category that the leaderboard is for. [username] is the username of the current user playing.
  /// [instance] is the instance of the Firestore database. It is just passed in the private constructor.
  /// It calls the private constructor and then waits for the data from the database to fill the [_entries] list.
  static Future<Leaderboard> createPublic(String category, String username, {FirebaseFirestore? instance, String? id}) async {
    var leaderboard = Leaderboard._create(category, username, true, instance: instance, id: id);
    await leaderboard.getData();
    return leaderboard;
  }

  /// Getter for the [_currentPlayer]'s position in the leaderboard
  int getCurrentPlayerPosition() {
    return _currentPlayer.getPosition;
  }

  /// Getter for the [_currentPlayer]'s points
  int getCurrentPlayerPoints() {
    return _currentPlayer.getScore;
  }

  /// Getter for the list of [LeaderboardEntry]s
  List<LeaderboardEntry> getEntries() {
    return _entries;
  }

  /// Removes the current user from the All leaderboard.
  Future<void> removeUserFromAllLeaderboard() async {
    await _docAll.update({
      _currentPlayer.getName: FieldValue.delete()
    });
  }

  /// Removes the current user from the current leaderboard.
  Future<void> removeUserFromPublicLeaderboards() async {
    await updateCurrentUserPoints(_currentPlayer.getScore * -1);
    await _collection.doc(_category).update({
      _currentPlayer.getName: FieldValue.delete()
    });
  }

  /// Updates the leaderboard in the database with the new points of the current user.
  ///
  /// It takes the [newPoints] as a parameter which should be added to the current points of the user and updates the database.
  /// The user's position in the leaderboard will decrease and vice versa. In the end, the All leaderboard is also updated in the same way.
  Future<void> updateCurrentUserPoints(int newPoints) async {
    int oldPoints = _currentPlayer.getScore;

    if(_currentPlayer.getPosition == -1){
      oldPoints = 0;
    }

    int lowestPoints = 9999999999;
    int lowestPosition = 1;
    DocumentReference doc = _collection.doc(_category);
    if(_isPublic){
      doc = _doc;
    }else{
      return;
    }

    // parse through the document and update the positions
    await doc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        for (String key in data.keys) {
          if (data[key]['points'] < newPoints + oldPoints &&
              data[key]['points'] >= oldPoints) {
            doc.set({
              key: {
                'points': data[key]['points'],
                'position': data[key]['position'] + 1
              }
            }, SetOptions(merge: true));
          }
          if (data[key]['points'] < lowestPoints &&
              data[key]['points'] > newPoints + oldPoints) {
            lowestPoints = data[key]['points'];
            lowestPosition = data[key]['position'] + 1;
          } else if (data[key]['points'] == newPoints + oldPoints) {
            lowestPoints = data[key]['points'];
            lowestPosition = data[key]['position'];
          }
        }
      }
    });

    await doc.set({
      _currentPlayer.getName: {
        'points': newPoints + oldPoints,
        'position': lowestPosition
      }
    }, SetOptions(merge: true));
    _currentPlayer = LeaderboardEntry(
        _currentPlayer.getName, newPoints + oldPoints, lowestPosition);

    await getData();
    if(_isPublic){
      await updateAllLeaderboard(newPoints);
    }
  }

  /// Updates the All leaderboard in the database with the new points of the current user.
  ///
  /// It takes the [newPoints] as a parameter which should be added to the current points of the user and updates the database.
  /// Then it finds the old points of the user in the All leaderboard for later calculations.
  Future<void> updateAllLeaderboard(int newPoints) async {
    int oldPoints = _currentPlayer.getScore;

    if(_currentPlayer.getPosition == -1){
      oldPoints = 0;
    }

    await _docAll.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        for (String key in data.keys) {
          if (key == _currentPlayer.getName) {
            oldPoints = data[key]['points'];
            break;
          }
        }
      }
    });
    int lowestPoints = 9999999999;
    int lowestPosition = 1;
    // parse through the document and update the positions
    await _docAll.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        for (String key in data.keys) {
          if (data[key]['points'] < newPoints + oldPoints &&
              data[key]['points'] >= oldPoints) {
            _docAll.set({
              key: {
                'points': data[key]['points'],
                'position': data[key]['position'] + 1
              }
            }, SetOptions(merge: true));
          }

          if (data[key]['points'] < lowestPoints &&
              data[key]['points'] > newPoints + oldPoints) {
            lowestPoints = data[key]['points'];
            lowestPosition = data[key]['position'] + 1;
          } else if (data[key]['points'] == newPoints + oldPoints) {
            lowestPoints = data[key]['points'];
            lowestPosition = data[key]['position'];
          }
        }
      }
    });
    await _docAll.set({
      _currentPlayer.getName: {
        'points': newPoints + oldPoints,
        'position': lowestPosition
      }
    }, SetOptions(merge: true));
    await getData();
  }

  /// Get the up-to-date leaderboard data from Firestore including data such as the [_currentPlayer] points and position,
  /// and sorted list of entries limited to 10.
  Future<void> getData() async {
    final docSnap;
    if(_isPublic){
      docSnap = await _doc.get();
    }else{
      return;
    }

    if(docSnap.data() == null){
      _entries = [];
      _currentPlayer = LeaderboardEntry(_currentPlayer.getName, 0, 0);
      return;
    }
    Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
    List<LeaderboardEntry> entries = [];

    int calculatedPosition = -1;
    int calculatedPoints = -1;
    for (String key in data.keys) {
      entries.add(
          LeaderboardEntry(key, data[key]['points'], data[key]['position']));
      if (key == _currentPlayer.getName) {
        calculatedPosition = data[key]['position'];
        calculatedPoints = data[key]['points'];
      }
    }
    _currentPlayer = LeaderboardEntry(
        _currentPlayer.getName, calculatedPoints, calculatedPosition);
    entries.sort((a, b) => b.getScore.compareTo(a.getScore));
    _entries = entries.sublist(0, min(10, entries.length));
  }

  /// Sort the entries in the current leaderboard [_entries] in descending order based on the points.
  void sortEntries() {
    _entries.sort((a, b) => b.getScore.compareTo(a.getScore));
  }

  /// Adds a new [LeaderboardEntry] to the existing list of entries. (testing purposes).
  ///
  /// It takes the [isTest] parameter which should be set to true if you are using it for testing.
  Future<void> _addEntry(LeaderboardEntry entry, {required bool isTest}) async {
    if(!isTest){
      throw Exception('This method is only for testing purposes');
    }
    _entries.add(entry);
  }


  /// create a new [Leaderboard] with 10 entries with random data (for testing purposes).
  ///
  /// It takes the [isTest] parameter which should be set to true if you are using it for testing.
  Future<void> createRandomLeaderboard({required bool isTest}) async {
    if(!isTest){
      throw Exception('This method is only for testing purposes');
    }
    _entries = [];
    _addEntry(LeaderboardEntry("Anika", 75, 6), isTest: true);
    _addEntry(LeaderboardEntry("John", 40, 11), isTest: true);
    _addEntry(LeaderboardEntry("Stanislav", 80, 4), isTest: true);
    _addEntry(LeaderboardEntry("Julia", 100, 1), isTest: true);
    _addEntry(LeaderboardEntry("Sophia", 85, 3), isTest: true);
    _addEntry(LeaderboardEntry("Marin", 80, 4), isTest: true);
    _addEntry(LeaderboardEntry("Nikol", 75, 6), isTest: true);
    _addEntry(LeaderboardEntry("Endia", 75, 6), isTest: true);
    _addEntry(LeaderboardEntry("Gullu", 60, 9), isTest: true);
    _addEntry(LeaderboardEntry("Savo", 95, 2), isTest: true);
    _addEntry(LeaderboardEntry("Mark", 55, 10), isTest: true);
  }

  /// Updates the database with the current leaderboard [_entries]. (for testing purposes).
  ///
  /// It takes the [isTest] parameter which should be set to true if you are using it for testing.
  Future<void> updateData({required bool isTest}) async {
    if(!isTest){
      throw Exception('This method is only for testing purposes');
    }
    DocumentReference doc = _collection.doc(_category);
    if(_isPublic){
      doc = _doc;
    }else{
      return;
    }
    sortEntries();
    // make document empty
    await doc.delete();
    // update document with new data from entries
    for (LeaderboardEntry entry in _entries) {
      await doc.set({
        entry.getName: {'points': entry.getScore, 'position': entry.getPosition}
      }, SetOptions(merge: true));
      if (_isPublic) {
        await _docAll.set({
          entry.getName: {
            'points': entry.getScore + 355,
            'position': entry.getPosition
          }
        }, SetOptions(merge: true));
      }
    }
  }
}
