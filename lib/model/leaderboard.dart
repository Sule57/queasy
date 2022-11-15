import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:queasy/model/leaderboard_entry.dart';

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

  /// Collection reference for the leaderboard in the database.
  late final CollectionReference _collection = FirebaseFirestore.instance.collection('leaderboard');

  /// Document reference for the leaderboard of the given category in the database.
  late final DocumentReference _doc = _collection.doc(_category);

  /// Document reference for the combined (All) leaderboard in the database.
  late final DocumentReference _docAll = _collection.doc('All');


  /// Private constructor for [Leaderboard] that deals with initializing the private parameters.
  Leaderboard._create(String category, String username) {
    _entries = [];
    _currentPlayer = LeaderboardEntry(username, -1, -1);
    _category = category;
  }


  /// Factory constructor for [Leaderboard] that creates a new [Leaderboard] object.
  /// It calls the private constructor and then waits for the data from the database.
  static Future<Leaderboard> create(String category, String username) async{
    var leaderboard = Leaderboard._create(category, username);

    await leaderboard.getData();
    return leaderboard;
  }

  /// Constructor for [Leaderboard] that creates a new [Leaderboard] object with given parameters.
  /// Used only if we have the List<LeaderboardEntry> [lb] that we want to copy into the new object.
  Leaderboard.withEntries(List<LeaderboardEntry> lb, this._category, this._currentPlayer) {
    _entries = List.from(lb);
  }

  /// Copy constructor for [Leaderboard] that creates a new [Leaderboard] object from another [Leaderboard] object.
  Leaderboard.fromLeaderboard(Leaderboard lb) {
    _entries = List.from(lb._entries);
    _category = lb._category;
    _currentPlayer = lb._currentPlayer;
  }

  /// Getter for the [currentUser]'s position in the leaderboard
  int getCurrentPlayerPosition() {
    return _currentPlayer.getPosition;
  }

  /// getter for the [currentUser]'s points
  int getCurrentPlayerPoints() {
    return _currentPlayer.getScore;
  }


  /// Adds a new [LeaderboardEntry] to the existing list of entries. (testing purposes)
  Future<void> _addEntry(LeaderboardEntry entry) async {
    _entries.add(entry);
  }

  /// Prints the [Leaderboard] list entries in the console. (testing purposes)
  void printEntries() {
    for (LeaderboardEntry entry in _entries) {
      print(entry.getPosition.toString() + ". " + entry.getName + ": " + entry.getScore.toString());
    }
  }

  /// Updates the leaderboard in the database with the new points of the current user.
  /// It takes the [newPoints] as a parameter which should be added to the current points of the user and updates the database.
  /// There is a difference between positive and negative [newPoints] because the leaderboard is sorted in descending order (based on points).
  /// If the [newPoints] are positive, the user's position in the leaderboard will decrease and vice versa.
  /// In the end, the All leaderboard is also updated in the same way.
  Future<void> updateCurrentUserPoints(int newPoints) async {
    int oldPoints = _currentPlayer.getScore;
    if(newPoints >= 0) {
      int lowestPoints = 2^32 - 1;
      int lowestPosition = 1;
      // parse through the document and update the positions
      await _doc.get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            if (data[key]['points'] < newPoints + oldPoints &&
                data[key]['points'] > oldPoints) {
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

      await getData();
    }else{
      int highestPoints = - 2^32 - 1;
      int highestPosition = - 2^32 - 1;

      await _doc.get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
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
      await getData();
    }

    await updateAllLeaderboard(newPoints);
  }


  /// Updates the All leaderboard in the database with the new points of the current user.
  /// It takes the [newPoints] as a parameter which should be added to the current points of the user and updates the database.
  /// Then it finds the old points of the user in the All leaderboard for later calculations.
  /// There is a difference between positive and negative [newPoints] because the leaderboard is sorted in descending order (based on points).
  /// If the [newPoints] are positive, the user's position in the leaderboard will decrease and vice versa.
  Future<void> updateAllLeaderboard(int newPoints) async{
    int oldPoints = -2^32 - 1;
    await _docAll.get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        for (String key in data.keys) {
          if (key == _currentPlayer.getName) {
            oldPoints = data[key]['points'];
            break;
          }
        }
      }
    });
    if(newPoints >= 0) {
      int lowestPoints = 2^32 - 1;
      int lowestPosition = 1;
      // parse through the document and update the positions
      await _docAll.get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            if (data[key]['points'] < newPoints + oldPoints &&
                data[key]['points'] > oldPoints) {
              _docAll.set({
                key: {
                  'points': data[key]['points'],
                  'position': data[key]['position'] + 1
                }
              }, SetOptions(merge: true));
            }
            // print(lowestPoints.toString() + ' ' + data[key]['points'].toString());
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
    }else{
      int highestPoints = - 2^32 - 1;
      int highestPosition = - 2^32 - 1;

      await _docAll.get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
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
    _addEntry(LeaderboardEntry("Julia", 100, 1));
    _addEntry(LeaderboardEntry("Savo", 95, 2));
    _addEntry(LeaderboardEntry("Sophia", 85, 3));
    _addEntry(LeaderboardEntry("Marin", 80, 4));
    _addEntry(LeaderboardEntry("Stanislav", 80, 4));
    _addEntry(LeaderboardEntry("Anika", 75, 6));
    _addEntry(LeaderboardEntry("Nikol", 75, 6));
    _addEntry(LeaderboardEntry("Endia", 75, 6));
    _addEntry(LeaderboardEntry("Gullu", 60, 9));
    _addEntry(LeaderboardEntry("Mark", 55, 10));
    _addEntry(LeaderboardEntry("John", 40, 11));
  }



  /// Factory method to create a new [Leaderboard] from a Firestore [DocumentSnapshot] and the current [Player].
  /// It takes the [DocumentSnapshot] and the [LeaderboardEntry] as parameters and returns a new [Leaderboard] with the data from the [DocumentSnapshot]
  /// limited to 10 entries.
  factory Leaderboard.fromFirestore(DocumentSnapshot doc, LeaderboardEntry currentPlayer) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<LeaderboardEntry> entries = [];

    int calculatedPosition = -1;
    int calculatedPoints = -1;
    for (String key in data.keys) {

      entries.add(LeaderboardEntry(key, data[key]['points'], data[key]['position']));
      if(key == currentPlayer.getName) {
        calculatedPosition = data[key]['position'];
        calculatedPoints = data[key]['points'];
      }
    }
    Leaderboard lb = Leaderboard.withEntries(entries, doc.id, LeaderboardEntry(currentPlayer.getName, calculatedPoints, calculatedPosition));
    lb.sortEntries();
    // get first 10 entries from the leaderboard lb
    lb._entries = lb._entries.sublist(0, min(10, lb._entries.length));
    return lb;
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
        entry.getName: {'points': entry.getScore + 355, 'position': entry.getPosition}
      }, SetOptions(merge: true));
    }
  }

  /// Map the leaderboard data to a [Leaderboard] firebase object for easier reading of the data.
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {};
    for (LeaderboardEntry entry in _entries) {
      data[entry.getName] = {'points': entry.getScore, 'position': entry.getPosition};
    }
    return data;
  }

  /// Get the up-to-date leaderboard data from Firestore.
  Future<void> getData() async {
    final collection = FirebaseFirestore.instance.collection('leaderboard');
    final docRef = collection.doc(_category).withConverter<Leaderboard>(
        fromFirestore: (snapshot,  _) => Leaderboard.fromFirestore(snapshot, _currentPlayer),
        toFirestore: (Leaderboard lb, _) => lb.toFirestore());
    final docSnap = await docRef.get();
    final lb = docSnap.data() as Leaderboard;
    if (lb != null) {
      this._entries = List.from(lb._entries);
      this._currentPlayer = LeaderboardEntry(lb._currentPlayer.getName, lb._currentPlayer.getScore, lb._currentPlayer.getPosition);
    } else {
      print('No such document.');
      this._entries = [];
    }
  }


}
