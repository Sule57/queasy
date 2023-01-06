import 'package:flutter/material.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/widgets/rounded-button.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({Key? key}) : super(key: key);

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

class AreYouSureDialog extends StatelessWidget {
  const AreYouSureDialog({Key? key}) : super(key: key);

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