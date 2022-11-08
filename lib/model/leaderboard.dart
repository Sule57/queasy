import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:queasy/model/leaderboard_entry.dart';

class Leaderboard {
  late List<LeaderboardEntry> _entries;

  late String _category;

  late LeaderboardEntry _currentPlayer;


  late CollectionReference collection = FirebaseFirestore.instance.collection('leaderboard');
  late DocumentReference doc = collection.doc(_category);
  late DocumentReference docAll = collection.doc('All');


  Leaderboard._create(String category, String username) {
    _entries = [];
    _currentPlayer = LeaderboardEntry(username, -1, -1);
    _category = category;
  }

  static Future<Leaderboard> create(String category, String username) async{
    var leaderboard = Leaderboard._create(category, username);

    await leaderboard.getData();
    return leaderboard;
  }

  Leaderboard.withEntries(List<LeaderboardEntry> lb, this._category, this._currentPlayer) {
    _entries = List.from(lb);
  }
  Leaderboard.fromLeaderboard(Leaderboard lb) {
    _entries = List.from(lb._entries);
    _category = lb._category;
    _currentPlayer = lb._currentPlayer;
  }

  // getter for currentUser's position in the leaderboard
  int getCurrentPlayerPosition() {
    return _currentPlayer.getPosition;
  }

  // getter for currentUser's points
  int getCurrentPlayerPoints() {
    return _currentPlayer.getScore;
  }


  // add a new Entry into the Leaderboard
  Future<void> addEntry(LeaderboardEntry entry) async {
    _entries.add(entry);
  }

  // print the leaderboard entries in Terminal
  void printEntries() {
    for (LeaderboardEntry entry in _entries) {
      print(entry.getPosition.toString() + ". " + entry.name + ": " + entry.score.toString());
    }
  }

  Future<void> updateCurrentUserPoints(int newPoints) async {
    int oldPoints = _currentPlayer.getScore;

    if(newPoints >= 0) {

      print("updating database with new entry" + _currentPlayer.getName + " " + newPoints.toString());

      int lowestPoints = 2^32 - 1;
      int lowestPosition = 0;
      // parse through the document and update the positions
      await doc.get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            if (data[key]['points'] < newPoints + oldPoints &&
                data[key]['points'] > oldPoints) {
              doc.set({
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
      await doc.set({
        _currentPlayer.getName: {
          'points': newPoints + oldPoints,
          'position': lowestPosition
        }
      }, SetOptions(merge: true));

      await getData();
    }else{
      int highestPoints = - 2^32 - 1;
      int highestPosition = - 2^32 - 1;

      await doc.get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            if (data[key]['points'] >= newPoints + oldPoints &&
                data[key]['points'] < oldPoints) {
              doc.set({
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
      await doc.set({
        _currentPlayer.getName: {
          'points': newPoints + oldPoints,
          'position': highestPosition
        }
      }, SetOptions(merge: true));
      await getData();
    }
  }

  // create a new leaderboard with 10 entries with random data
  Future<void> createRandomLeaderboard() async {
    _entries = [];
    addEntry(LeaderboardEntry("Julia", 100, 1));
    addEntry(LeaderboardEntry("Savo", 95, 2));
    addEntry(LeaderboardEntry("Sophia", 85, 3));
    addEntry(LeaderboardEntry("Marin", 80, 4));
    addEntry(LeaderboardEntry("Stanislav", 80, 4));
    addEntry(LeaderboardEntry("Anika", 75, 6));
    addEntry(LeaderboardEntry("Nikol", 75, 6));
    addEntry(LeaderboardEntry("Endia", 75, 6));
    addEntry(LeaderboardEntry("Gullu", 60, 9));
    addEntry(LeaderboardEntry("Mark", 55, 10));
    addEntry(LeaderboardEntry("John", 40, 11));
  }



  // get the leaderboard data from firestore
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

  // sort the leaderboard entries by points and update the position
  void sortEntries() {
    _entries.sort((a, b) => b.score.compareTo(a.score));
  }

  // update the leaderboard data in firestore
  Future<void> updateData() async {
    sortEntries();
    // make document empty
    await doc.delete();
    // update document with new data from entries

    for (LeaderboardEntry entry in _entries) {
      await doc.set({
        entry.name: {'points': entry.score, 'position': entry.position}
      }, SetOptions(merge: true));

    }
  }

  // map the leaderboard data to a Leaderboard firebase object
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {};
    for (LeaderboardEntry entry in _entries) {
      data[entry.getName] = {'points': entry.score, 'position': entry.getPosition};
    }
    return data;
  }

  // get the leaderboard data from firestore
  // this is how you get the data: Leaderboard lb = await Leaderboard([], 'science', -1, 'john').getData();
  // -1 is the default value for currentUserPosition (unknown), position of 'john' user
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
