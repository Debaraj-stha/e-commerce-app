import 'package:flutter/material.dart';

class BuildHeading extends StatelessWidget {
  const BuildHeading({super.key, this.text, this.color = Colors.black});
  final String? text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: Theme.of(context)
          .primaryTextTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}
