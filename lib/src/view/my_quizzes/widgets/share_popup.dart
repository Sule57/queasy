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

class ShareDialog extends StatelessWidget {
  const ShareDialog({Key? key, required this.quizId}) : super(key: key);
  final String quizId;

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
