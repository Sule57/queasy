import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/theme_provider.dart';
import '../../../src.dart';
import '../play_quiz/play_quiz_view.dart';

class JoinQuizPopup extends StatelessWidget {
  const JoinQuizPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return AlertDialog(
      backgroundColor: theme.colorScheme.primary,
      title: Container(
        alignment: Alignment.topCenter,
        child: Text(
          'Enter key',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// User input
            Container(
                height: MediaQuery.of(context).size.height * .07,
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.background,
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: theme.colorScheme.onPrimary),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ))
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: theme.colorScheme.onSecondary),
              ),
              onPressed: () {
                textController.clear();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      theme.colorScheme.secondary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
            ),

            ///[ElevatedButton] to confirm the entered key
            ElevatedButton(
              child: Text("Join",
                  style: TextStyle(color: theme.colorScheme.onSecondary)),
              onPressed: () async {
                if (textController.text.isNotEmpty) {
                  // /confirmKey method is called from the controller
                  // /result is saved in [success] variable
                  bool success =
                      await Quiz.checkIfQuizExists(id: textController.text);

                  if (success) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlayQuizView(
                          id: textController.text,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Invalid key',
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    theme.colorScheme.tertiary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
