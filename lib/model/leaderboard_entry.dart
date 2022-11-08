class LeaderboardEntry {
  final String name;
  int score;
  int position;

  LeaderboardEntry(this.name, this.score, this.position);

  //getters
  String get getName => name;
  int get getScore => score;
  int get getPosition => position;

  //setters
  set setScore(int score) => this.score = score;
  set setPosition(int position) => this.position = position;
}
