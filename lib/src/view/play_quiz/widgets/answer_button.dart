/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/theme_provider.dart';
import '../play_quiz_provider.dart';

/// Widget for every answer of the quiz.
///
/// It is a [StatefulWidget] that displays the answer text and changes
/// its color when the user clicks it depending on whether the answer is correct
/// or not.
///
/// It takes a parameter [index] to determine which answer to display.
class AnswerButton extends StatefulWidget {
  /// Index of the answer to display.
  final int index;

  const AnswerButton({super.key, required this.index});

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

/// State for [AnswerButton].
///
/// This state is responsible for updating the view when the user clicks an
/// answer.
class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  /// Controls the time of the Tween animation.
  late AnimationController _animationController;

  /// Used to animate the answer button when the user clicks it. It controls the
  /// color of the button.
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
      reverseDuration: const Duration(milliseconds: 0),
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
    var provider = Provider.of<PlayQuizProvider>(context);
    String text = provider.getAnswerText(widget.index);
    bool isCorrect = provider.isAnswerCorrect(widget.index);
    bool isClicked = provider.currentQuestionAnswered;

    _colorTween = ColorTween(
      begin: Provider.of<ThemeProvider>(context)
          .currentTheme
          .colorScheme
          .background,
      end: isCorrect ? const Color(0xff9fc490) : const Color(0xfff19c79),
    ).animate(_animationController);
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    }

    return Expanded(
      child: Consumer<PlayQuizProvider>(builder: (context, quizProvider, _) {
        return Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedBuilder(
            animation: _colorTween,
            builder: (context, child) => ElevatedButton(
              onPressed: isClicked
                  ? null
                  : () {
                      quizProvider.editScore(isCorrect);
                      provider.toggleQuestionAnswered();
                      _animationController.forward();
                      Future.delayed(const Duration(milliseconds: 500))
                          .then((_) {
                        _animationController.reverse();
                        quizProvider.nextQuestion();
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                disabledBackgroundColor: _colorTween.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .colorScheme
                      .onBackground,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
