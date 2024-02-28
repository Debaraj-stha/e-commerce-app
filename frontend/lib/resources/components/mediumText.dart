import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediumText extends StatelessWidget {
  const MediumText({super.key, this.text, this.color = Colors.black});
  final String? text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(text ?? "",
        style: Theme.of(context).primaryTextTheme.bodyMedium!);
  }
}
