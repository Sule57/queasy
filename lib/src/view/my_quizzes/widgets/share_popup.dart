/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';

/// Dialog that is shown when the user clicks on the share button in the
/// menu shown in the [QuizListTile]. It shows the key and a button to copy it
/// to clipboard. It takes a parameter when it is created, [quizId], which
/// is the key that is copied to clipboard.
class ShareDialog extends StatelessWidget {
  /// Constructor for the [ShareDialog].
  const ShareDialog({Key? key, required this.quizId}) : super(key: key);

  /// Id of the quiz to share.
  final String quizId;

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return AlertDialog(
      backgroundColor: theme.colorScheme.primary,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Key: $quizId',
            style: theme.textTheme.headline4?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            color: theme.colorScheme.onPrimary,
            onPressed: () {
              // Share.share(quizId, subject: 'Play this quiz with me!');
              Clipboard.setData(ClipboardData(text: quizId));

              Future.delayed(Duration.zero, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Copied to clipboard'),
                  ),
                );
              });

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
