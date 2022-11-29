class Answer {
  String _text;
  bool _isCorrect;

  Answer(this._text, this._isCorrect);

  Answer.fromJson(Map<String, dynamic> json)
      : _text = json['text'],
        _isCorrect = json['isCorrect'];

  get text => _text;
  get isCorrect => _isCorrect;

  void setText(String text) {
    _text = text;
  }
  void setCorrect(bool isCorrect) {
    _isCorrect = isCorrect;
}
