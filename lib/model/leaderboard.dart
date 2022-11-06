import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:queasy/model/leaderboard_entry.dart';

class Leaderboard {
  late List<LeaderboardEntry> entries;

  Leaderboard(List<LeaderboardEntry> lb) {
    entries = List.from(lb);
  }

  // add a new Entry into the Leaderboard
  Future<void> addEntry(LeaderboardEntry entry) async {
    entries.add(entry);
  }

  // print the leaderboard entries in Terminal
  void printEntries() {
    for (LeaderboardEntry entry in entries) {
      print(entry.name + ": " + entry.score.toString());
    }
  }

  // get the leaderboard data from firestore
  factory Leaderboard.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<LeaderboardEntry> entries = [];

    data.forEach((key, value) {
      entries.add(LeaderboardEntry(value['username'], value['points']));
    });
    return Leaderboard(entries);
  }

  // map the leaderboard data to a Leaderboard firebase object
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {};
    int i = 0;
    for (LeaderboardEntry entry in entries) {
      data[i.toString()] = {'username': entry.name, 'points': entry.score};
      i++;
    }
    return data;
  }

  // get the leaderboard data from firestore
  // this is how you get the data: Leaderboard lb = await Leaderboard([]).getData('science');
  Future<Leaderboard> getData(String category) async {
    final collection = FirebaseFirestore.instance.collection('leaderboard');
    final docRef = collection.doc(category).withConverter<Leaderboard>(
        fromFirestore: (snapshot, _) => Leaderboard.fromFirestore(snapshot),
        toFirestore: (Leaderboard lb, _) => lb.toFirestore());
    final docSnap = await docRef.get();
    final lb = docSnap.data() as Leaderboard;
    if (lb != null) {
      return lb;
    } else {
      print('No such document.');
      return Leaderboard([]);
    }
  }


}
