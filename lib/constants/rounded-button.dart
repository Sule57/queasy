import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.buttonName,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final String buttonName;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.07,
      width: size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 24,
            color: textColor ?? Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
