import 'package:flutter/material.dart';

class BuildTextButton extends StatelessWidget {
  const BuildTextButton(
      {super.key, required this.child, required this.onPressed, this.color});
  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
      child: child,
    );
  }
}
