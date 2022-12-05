import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonName;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function()? onPressed;

  const RoundedButton({
    Key? key,
    required this.buttonName,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: height ?? size.height * 0.07,
      alignment: Alignment.center,
      width: width ?? size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: borderColor ?? Colors.transparent,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: fontSize ?? 24,
            color: textColor ?? Theme.of(context).colorScheme.onPrimary,
            fontWeight: fontWeight ?? FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
