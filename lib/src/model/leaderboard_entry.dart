/// Class of a leaderboard entry. This class is used to store the data of a leaderboard entry.
class LeaderboardEntry {
  /// The username of the user
  late final String _name;
  /// The score of the user
  late final int _score;
  /// The position of the user
  late final int _position;

  /// Constructor for the LeaderboardEntry class
  LeaderboardEntry(this._name, this._score, this._position);

  /// Getter for the name
  String get getName => _name;

  /// Getter for the score
  int get getScore => _score;

  /// Getter for the position
  int get getPosition => _position;

  /// Setter for the score
  set setScore(int score) => _score = score;

  /// Setter for the position
  set setPosition(int position) => _position = position;
}