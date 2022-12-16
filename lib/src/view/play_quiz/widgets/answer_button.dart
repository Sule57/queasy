import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../quiz_provider.dart';

/// Widget for every answer of the quiz.
///
/// It is a [StatefulWidget] that displays the answer text and changes
/// its color when the user clicks it depending on whether the answer is correct
/// or not.
/// It takes a parameter [index] to determine which answer to display.
class AnswerButton extends StatefulWidget {
  final int index;

  const AnswerButton({super.key, required this.index});

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

/// State for [AnswerButton].
///
/// This state is responsible for updating the view when the user clicks an
/// answer.
///
/// It has a parameter [_animationController] that controls the time of the
/// Tween animation.
/// It has a parameter [_colorTween] that is used to animate the answer button
/// when the user clicks it. It controls the color of the button.
class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  /// Initializes the state.
  ///
  /// Creates an [AnimationController] that is used to animate the answer
  /// button when the user clicks it.
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  /// Disposes the state.
  ///
  /// Disposes the [_animationController] when the state is disposed.
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Builds the view.
  ///
  /// Specifies the color for [_colorTween] variable using the
  /// [_animationController] depending on whether the answer is correct or not.
  /// It displays the answer text in a container that will turn green when
  /// the user clicks on it if the answer is correct, and red if it is not.
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
