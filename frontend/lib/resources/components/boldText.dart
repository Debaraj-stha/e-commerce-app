import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  const BoldText({
    super.key,
    this.text,
  });
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(
          fontFamily: "Roboto", fontSize: 20, fontWeight: FontWeight.w500),
    );
  }
}
