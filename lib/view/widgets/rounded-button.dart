import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.buttonName,
  }) : super(key: key);

  final String buttonName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.05,
      width: size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          buttonName,
          style: Theme.of(context).textTheme.headline2?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                height: 1,
              ),
        ),
      ),
    );
  }
}
