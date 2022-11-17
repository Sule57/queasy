class Answer {
  final String _text;
  final bool _isCorrect;

  Answer(this._text, this._isCorrect);

  bool isCorrect() {
    return _isCorrect;
  }

  String getText() {
    return _text;
  }
}
