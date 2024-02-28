import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmallText extends StatelessWidget {
  const SmallText({super.key, this.text, this.color = Colors.black});
  final String? text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(text ?? "",
        style: Theme.of(context).primaryTextTheme.bodySmall!);
  }
}
