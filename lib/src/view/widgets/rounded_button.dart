import 'package:flutter/material.dart';

///This is RoundedButton class that provides template button for other classes to use
///
///It has following properties:
///[buttonName] which is to display the button text and it's a required property
///[backgroundColor], [textColor], [borderColor] are for specifying colors
///[width], [height], [fontSize] and [fontWeight]are to determine the size of the button and text
///[onPressed] is to pass a function that will be called when the button is clicked
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

  /// Builds the RoundedButton
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: height ?? size.height * 0.07,
      alignment: Alignment.center,
      width: width ?? size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
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
            fontSize: fontSize ?? 22,
            color: textColor ?? Theme.of(context).colorScheme.onPrimary,
            fontWeight: fontWeight ?? FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
