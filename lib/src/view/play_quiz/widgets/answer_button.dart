import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../quiz_provider.dart';

class AnswerButton extends StatefulWidget {
  final int index;

  const AnswerButton({super.key, required this.index});

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuizProvider>(context);
    String text = provider.getAnswerText(widget.index);
    bool isCorrect = provider.isAnswerCorrect(widget.index);

    _colorTween = ColorTween(
      begin: Colors.white,
      end: isCorrect ? Colors.green : Colors.red,
    ).animate(_animationController);
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    }

    return Expanded(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedBuilder(
          animation: _colorTween,
          builder: (context, child) => ElevatedButton(
            onPressed: () {
              if (_animationController.status == AnimationStatus.completed) {
                _animationController.reverse();
              } else {
                _animationController.forward();
                Future.delayed(const Duration(milliseconds: 500)).then((_) {
                  context.read<QuizProvider>().editScore(isCorrect);

                  _animationController.reverse();
                  context.read<QuizProvider>().nextQuestion();
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _colorTween.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ),
    );
  }
}
