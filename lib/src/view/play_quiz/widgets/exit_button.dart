/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/widgets/rounded_button.dart';

/// Widget for the button to exit the quiz
///
/// This widget is used in [PlayQuizView] to exit the quiz, so the user can
/// return to the home view without finishing the quiz. Before popping the
/// view, it shows a dialog to confirm the action.
class ExitButton extends StatelessWidget {
  const ExitButton({Key? key}) : super(key: key);

  /// Builds the view.
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width / 5,
      height: 40,
      child: RoundedButton(
        buttonName: 'Exit',
        fontSize: 15,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AreYouSureDialog(),
          );
        },
      ),
    );
  }
}

/// Dialog to confirm the exit of the quiz.
///
/// This dialog is shown when the user presses the exit button in [PlayQuizView]
/// or the back button. It asks the user if they are sure they want to exit the
/// quiz. If the user presses "Accept", the view is popped. If the user presses
/// "Cancel", the dialog is closed.
class AreYouSureDialog extends StatelessWidget {
  const AreYouSureDialog({Key? key}) : super(key: key);

  /// Builds the view.
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('You will lose all your progress.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeView()));
          },
          child: const Text('Exit'),
        ),
      ],
    );
  }
}
