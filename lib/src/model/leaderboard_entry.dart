/// Class of a leaderboard entry. This class is used to store the data of a leaderboard entry
/// and its setters and getters.
class LeaderboardEntry {
  /// Represents the username of the user
  late final String _name;

  /// Represents the score of the user
  late final int _score;

  /// Represents the position of the user
  late final int _position;

  /// Constructor for the LeaderboardEntry class takes the parameters
  /// [_name], [_score] and [_position]
  LeaderboardEntry(this._name, this._score, this._position);

  /// Getter for the name
  String get getName => _name;

  /// Getter for the score
  int get getScore => _score;

  /// Getter for the [_position] field
  int get getPosition => _position;

  /// Setter for the [_score] field
  set setScore(int score) => _score = score;

  /// Setter for the [_position]
  set setPosition(int position) => _position = position;
}
