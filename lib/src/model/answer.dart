class Answer {
  final String _text;
  final bool _isCorrect;

  Answer(this._text, this._isCorrect);

  Answer.fromJson(Map<String, dynamic> json)
      : _text = json['text'],
        _isCorrect = json['isCorrect'];

  bool isCorrect() {
    return _isCorrect;
  }

  String getText() {
    return _text;
  }
}
