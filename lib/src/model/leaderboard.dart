import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/leaderboard_entry.dart';
import 'package:queasy/src/model/profile.dart';

/// This is the Model class for the Leaderboard
///
/// It is responsible for connecting the [Leaderboard] to the [LeaderboardEntry]s
/// in the database. It also contains the logic for updating the leaderboard in the database.
///
/// [_entries] is a list of all the [LeaderboardEntry]s in the database.
///
/// [_category] is the name of the category that the leaderboard is for.
///
/// [_owner] is the username of the owner of the category that the leaderboard is for.
///
/// [_currentPlayer] is the Player that is currently logged in and is playing the game.
///
/// [_firebaseFirestore] is the instance of the [FirebaseFirestore] database.
///
/// [_collection] is the collection in the database that the leaderboard is stored in.
///
/// [_doc] is the document in the database that the leaderboard is stored in for public leaderboards.
///
/// [_docPriv] is the document in the database that the leaderboard is stored in for private leaderboards.
///
/// [_isPublic] is a boolean that is true if the leaderboard is public and false if it is private.
class Leaderboard {
  late List<LeaderboardEntry> _entries = [];
  late String _category;
  late String _owner;
  late LeaderboardEntry _currentPlayer;
  late final bool _isPublic;

  late final _firebaseFirestore;
  late final CollectionReference _collection = _firebaseFirestore.collection('leaderboard');
  late final DocumentReference _doc = _collection.doc(_category);
  late final DocumentReference _docPriv = _collection.doc(getCurrentUserID()! + '-' + _category);
  late final DocumentReference _docAll = _collection.doc('All');

  /// Private constructor for [Leaderboard] that deals with initializing the private parameters.
  ///
  /// [category] is the name of the category that the leaderboard is for. [username] is the username of the current user playing.
  /// [isPublic] is a boolean that is true if the leaderboard is public and false if it is private.
  Leaderboard._create(String category, String username, bool isPublic) {
    _entries = [];
    _currentPlayer = LeaderboardEntry(username, -1, -1);
    _category = category;
    _firebaseFirestore = FirebaseFirestore.instance;
    this._isPublic = isPublic;
  }

  /// Factory constructor for public [Leaderboard] that creates a new [Leaderboard] object.
  ///
  /// It calls the private constructor and then waits for the data from the database to fill the [_entries] list.
  static Future<Leaderboard> createPublic(String category, String username) async {
    var leaderboard = Leaderboard._create(category, username, true);
    await leaderboard.getData();
    return leaderboard;
  }

  /// Factory constructor for private [Leaderboard] that creates a new [Leaderboard] object.
  ///
  /// It calls the private constructor and then waits for the data from the database to fill the [_entries] list.
  static Future<Leaderboard> createPrivate(String category, String username) async {
    var leaderboard = Leaderboard._create(category, username, false);
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

  /// Updates the leaderboard in the database with the new points of the current user.
  ///
  /// It takes the [newPoints] as a parameter which should be added to the current points of the user and updates the database.
  /// The user's position in the leaderboard will decrease and vice versa. In the end, the All leaderboard is also updated in the same way.
  Future<void> updateCurrentUserPoints(int newPoints) async {
    int oldPoints = _currentPlayer.getScore;
    int lowestPoints = 9999999999;
    int lowestPosition = 1;
    DocumentReference doc = _collection.doc(_category);
    if(_isPublic){
      doc = _doc;
    }else{
      doc = _docPriv;
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
    int oldPoints = -9999999999;

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
      docSnap = await _docPriv.get();
    }
    print(docSnap.toString());
    print(getCurrentUserID()! + '-' + _category);
    Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
    print(data.toString());
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

  /// Constructor for [Leaderboard] that creates a new [Leaderboard] object with the Mock database for testing purposes.
  ///
  /// [_firebaseFirestore] in this case it the mock database while the rest of the parameters are the same as other constructors.
  /// Used for testing of the public categories.
  Leaderboard.testPublic(
      this._category,
      String username,
      this._firebaseFirestore,
      ) {
    _entries = [];
    _currentPlayer = LeaderboardEntry(username, -1, -1);
    _isPublic = true;
  }

  /// Constructor for [Leaderboard] that creates a new [Leaderboard] object with the Mock database for testing.
  ///
  /// [_firebaseFirestore] in this case it the mock database while the rest of the parameters are the same as other constructors.
  /// Used for testing of the private categories.
  Leaderboard.testPrivate(
      this._category,
      String username,
      this._firebaseFirestore,
      ) {
    _entries = [];
    _currentPlayer = LeaderboardEntry(username, -1, -1);
    _isPublic = false;
  }

  /// Adds a new [LeaderboardEntry] to the existing list of entries. (testing purposes)
  Future<void> _addEntry(LeaderboardEntry entry) async {
    _entries.add(entry);
  }

  /// Prints the [Leaderboard] list entries in the console. (testing purposes)
  void printEntries() {
    for (LeaderboardEntry entry in _entries) {
      print(entry.getPosition.toString() +
          ". " +
          entry.getName +
          ": " +
          entry.getScore.toString());
    }
  }

  /// create a new [Leaderboard] with 10 entries with random data (for testing purposes).
  Future<void> createRandomLeaderboard() async {
    _entries = [];
    _addEntry(LeaderboardEntry("Anika", 75, 6));
    _addEntry(LeaderboardEntry("John", 40, 11));
    _addEntry(LeaderboardEntry("Stanislav", 80, 4));
    _addEntry(LeaderboardEntry("Julia", 100, 1));
    _addEntry(LeaderboardEntry("Sophia", 85, 3));
    _addEntry(LeaderboardEntry("Marin", 80, 4));
    _addEntry(LeaderboardEntry("Nikol", 75, 6));
    _addEntry(LeaderboardEntry("Endia", 75, 6));
    _addEntry(LeaderboardEntry("Gullu", 60, 9));
    _addEntry(LeaderboardEntry("Savo", 95, 2));
    _addEntry(LeaderboardEntry("Mark", 55, 10));
  }

  /// Updates the database with the current leaderboard [_entries]. (for testing purposes)
  Future<void> updateData() async {
    DocumentReference doc = _collection.doc(_category);
    if(_isPublic){
      doc = _doc;
    }else{
      doc = _docPriv;
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
