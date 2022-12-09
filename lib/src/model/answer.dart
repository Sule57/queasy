
///The Answer class is used to store the answer and implements Answer methods (still under construction as of 11/12/2020)
///The String parameter [_text] is the text of the answer and is initialized in the constructor, it can also be changed using the method [setText]
///The bool parameter [_isCorrect] is true if the answer is correct and false if it is not. It is initialized in the constructor and can be changed using the method [setCorrect].
///Also, there should only be one correct answer of the question, but this is handled inside of the question class at the current moment.
class Answer {
  String _text;
  bool _isCorrect;

  /// The default Answer constructor represents the default constructor for the Answer class when it is being initialized inside of the code,
  /// this constructor takes in the parameters [text] and [isCorrect] and sets them to the private variables [_text] and [_isCorrect]
  Answer(this._text, this._isCorrect);

  /// Answer.fromJson is a constructor that is used to create an Answer object from a json object that is passed in as a parameter.
  /// This constructor takes in the parameter [json] which is a json object that is usually passed from the firebase database.
  /// This constructor then sets the private variables [_text] and [_isCorrect] to the values of the json object.
  Answer.fromJson(Map<String, dynamic> json)
      : _text = json['text'],
        _isCorrect = json['isCorrect'];

  /// The method [getText] is used to return the text of the answer.
  get text => _text;
  /// The method [isCorrect] is used to return the boolean value of [_isCorrect], a.k.a to find out if the Answer that is being looked at, is correct or not.
  get isCorrect => _isCorrect;

  /// The method [setText] is used to set the text of the answer to a new value, to be implemented to automatically change it in firebase in the future
  void setText(String text) {
    _text = text;
  }

  /// The method [setCorrect] is used to set the boolean value of [_isCorrect] to a new value, to be implemented to automatically change it in firebase in the future
  void setCorrect(bool isCorrect) {
    _isCorrect = isCorrect;
  }
}
