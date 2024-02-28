import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  const BigText({super.key, this.text, this.color = Colors.black});
  final String? text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(text ?? "",
        style: Theme.of(context).primaryTextTheme.bodyLarge!);
  }
}
