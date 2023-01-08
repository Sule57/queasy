/// The Answer class is used to locally store an answer to a question and it's
/// isCorrect value.
class Answer {
  ///The String parameter _text is the text of the answer and is initialized
  ///in the constructor, it can also be changed using the method [setText].
  String _text;
  ///The bool parameter _isCorrect is true if the answer is correct and false if
  /// it is not. It is initialized in the constructor and can be changed using
  /// the method [setCorrect].
  bool _isCorrect;

  /// The default Answer constructor represents the default constructor for the
  /// [Answer] class when it is being initialized inside of the code, this
  /// constructor takes in the parameters [text] and [isCorrect] and sets them
  /// to the private variables [_text] and [_isCorrect].
  Answer(this._text, this._isCorrect);

  /// Answer.fromJson is a constructor that is used to create an instance
  /// of the [Answer] class from a [json] object. It takes the value of the
  /// key 'text' from the [json] object and sets it to the private variable
  /// [_text]. It also takes the value of the key 'isCorrect' from the [json]
  /// object and sets it to the private variable [_isCorrect].
  Answer.fromJson(Map<String, dynamic> json)
      : _text = json['text'],
        _isCorrect = json['isCorrect'];

  /// Returns the value of the private variable [_text] which represents the
  /// actual text of the answer.
  get text => _text;
  /// Returns the value of the private variable [_isCorrect] which represents
  /// whether the answer is correct or not.
  get isCorrect => _isCorrect;

  /// The method [setText] is used to set the text of the answer to a new value,
  /// it takes in the parameter [text] which is a String and sets it to the
  /// private variable [_text].
  void setText(String text) {
    _text = text;
  }

  /// The method [setCorrect] is used to set the boolean value of [_isCorrect]
  /// to a new value, it takes in the parameter [isCorrect] which is a bool and
  /// sets it to the private variable [_isCorrect].
  void setCorrect(bool isCorrect) {
    _isCorrect = isCorrect;
  }
}
