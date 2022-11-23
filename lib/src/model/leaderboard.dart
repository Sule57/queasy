import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/leaderboard_entry.dart';

/// This is the Model class for the Leaderboard
///
/// It is responsible for connecting the [Leaderboard] to the [LeaderboardEntry]s
/// in the database. It also contains the logic for updating the leaderboard in the database.
class Leaderboard {
  /// The [LeaderboardEntry]s in the database for the leaderboard with the given category.
  late List<LeaderboardEntry> _entries;

  /// The category of the leaderboard.
  late String _category;

  /// [LeaderboardEntry] of the category of the currently logged-in user.
  late LeaderboardEntry _currentPlayer;

  /// Firestore instance for the database.
  late final _firebaseFirestore;

  /// Collection reference for the leaderboard in the database.
  late final CollectionReference _collection =
      _firebaseFirestore.collection('leaderboard');

  /// Document reference for the leaderboard of the given category in the database.
  late final DocumentReference _doc = _collection.doc(_category);

  /// Document reference for the combined (All) leaderboard in the database.
  late final DocumentReference _docAll = _collection.doc('All');

  /// Private constructor for [Leaderboard] that deals with initializing the private parameters.
  Leaderboard._create(String category, String username) {
    _entries = [];
    _currentPlayer = LeaderboardEntry(username, -1, -1);
    _category = category;
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  /// Factory constructor for [Leaderboard] that creates a new [Leaderboard] object.
  /// It calls the private constructor and then waits for the data from the database.
  static Future<Leaderboard> create(String category, String username) async {
    var leaderboard = Leaderboard._create(category, username);

    await leaderboard.getData();
    return leaderboard;
  }

  /// Constructor for [Leaderboard] that creates a new [Leaderboard] object with given parameters.
  /// Used only if we have the List<LeaderboardEntry> [lb] that we want to copy into the new object.
  Leaderboard.withEntries(
      List<LeaderboardEntry> lb, this._category, this._currentPlayer) {
    _entries = List.from(lb);
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  /// Copy constructor for [Leaderboard] that creates a new [Leaderboard] object from another [Leaderboard] object.
  Leaderboard.fromLeaderboard(Leaderboard lb) {
    _entries = List.from(lb._entries);
    _category = lb._category;
    _currentPlayer = lb._currentPlayer;
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  /// Constructor for [Leaderboard] that creates a new [Leaderboard] object with the Mock database for testing.
  Leaderboard.test(
    this._category,
    String username,
    this._firebaseFirestore,
  ) {
    _entries = [];
    _currentPlayer = LeaderboardEntry(username, -1, -1);
  }

  /// Getter for the [currentUser]'s position in the leaderboard
  int getCurrentPlayerPosition() {
    return _currentPlayer.getPosition;
  }

  /// getter for the [currentUser]'s points
  int getCurrentPlayerPoints() {
    return _currentPlayer.getScore;
  }

  /// Getter for the list of [LeaderboardEntry]s
  List<LeaderboardEntry> getEntries() {
    return _entries;
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

  /// Updates the leaderboard in the database with the new points of the current user.
  /// It takes the [newPoints] as a parameter which should be added to the current points of the user and updates the database.
  /// There is a difference between positive and negative [newPoints] because the leaderboard is sorted in descending order (based on points).
  /// If the [newPoints] are positive, the user's position in the leaderboard will decrease and vice versa.
  /// In the end, the All leaderboard is also updated in the same way.
  Future<void> updateCurrentUserPoints(int newPoints) async {
    int oldPoints = _currentPlayer.getScore;
    if (newPoints >= 0) {
      int lowestPoints = 9999999999;
      int lowestPosition = 1;
      // parse through the document and update the positions
      await _doc.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            if (data[key]['points'] < newPoints + oldPoints &&
                data[key]['points'] >= oldPoints) {
              _doc.set({
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

      await _doc.set({
        _currentPlayer.getName: {
          'points': newPoints + oldPoints,
          'position': lowestPosition
        }
      }, SetOptions(merge: true));
      _currentPlayer = LeaderboardEntry(
          _currentPlayer.getName, newPoints + oldPoints, lowestPosition);

      await getData();
    } else {
      int highestPoints = -9999999999;
      int highestPosition = -9999999999;

      await _doc.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            if (data[key]['points'] >= newPoints + oldPoints &&
                data[key]['points'] < oldPoints) {
              _doc.set({
                key: {
                  'points': data[key]['points'],
                  'position': data[key]['position'] - 1
                }
              }, SetOptions(merge: true));
            }
            if (data[key]['points'] > highestPoints &&
                data[key]['points'] <= newPoints + oldPoints) {
              highestPoints = data[key]['points'];
              highestPosition = data[key]['position'] - 1;
            } else if (data[key]['points'] == newPoints + oldPoints) {
              highestPoints = data[key]['points'];
              highestPosition = data[key]['position'];
            }
          }
        }
      });
      await _doc.set({
        _currentPlayer.getName: {
          'points': newPoints + oldPoints,
          'position': highestPosition
        }
      }, SetOptions(merge: true));

      _currentPlayer = LeaderboardEntry(
          _currentPlayer.getName, newPoints + oldPoints, highestPosition);
      await getData();
    }
    await updateAllLeaderboard(newPoints);
  }

  /// Updates the All leaderboard in the database with the new points of the current user.
  /// It takes the [newPoints] as a parameter which should be added to the current points of the user and updates the database.
  /// Then it finds the old points of the user in the All leaderboard for later calculations.
  /// There is a difference between positive and negative [newPoints] because the leaderboard is sorted in descending order (based on points).
  /// If the [newPoints] are positive, the user's position in the leaderboard will decrease and vice versa.
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
    if (newPoints >= 0) {
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
    } else {
      int highestPoints = -9999999999;
      int highestPosition = -9999999999;

      await _docAll.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            if (data[key]['points'] >= newPoints + oldPoints &&
                data[key]['points'] < oldPoints) {
              _docAll.set({
                key: {
                  'points': data[key]['points'],
                  'position': data[key]['position'] - 1
                }
              }, SetOptions(merge: true));
            }
            if (data[key]['points'] > highestPoints &&
                data[key]['points'] <= newPoints + oldPoints) {
              highestPoints = data[key]['points'];
              highestPosition = data[key]['position'] - 1;
            } else if (data[key]['points'] == newPoints + oldPoints) {
              highestPoints = data[key]['points'];
              highestPosition = data[key]['position'];
            }
          }
        }
      });
      await _docAll.set({
        _currentPlayer.getName: {
          'points': newPoints + oldPoints,
          'position': highestPosition
        }
      }, SetOptions(merge: true));
      await getData();
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

  /// Sort the entries in the current leaderboard [_entries] in descending order based on the points.
  void sortEntries() {
    _entries.sort((a, b) => b.getScore.compareTo(a.getScore));
  }

  /// Updates the database with the current leaderboard [_entries]. (for testing purposes)
  Future<void> updateData() async {
    sortEntries();
    // make document empty
    await _doc.delete();
    // update document with new data from entries
    for (LeaderboardEntry entry in _entries) {
      await _doc.set({
        entry.getName: {'points': entry.getScore, 'position': entry.getPosition}
      }, SetOptions(merge: true));
      await _docAll.set({
        entry.getName: {
          'points': entry.getScore + 355,
          'position': entry.getPosition
        }
      }, SetOptions(merge: true));
    }
  }

  /// Get the up-to-date leaderboard data from [Firestore] including data such as the [_currentPlayer] points and position,
  /// and sorted list of entries limited to 10.
  Future<void> getData() async {
    final docSnap = await _doc.get();
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
}
