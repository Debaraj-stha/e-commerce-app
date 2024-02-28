import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'buildIcon.dart';
import 'mediumText.dart';

class BuildListTile extends StatelessWidget {
  const BuildListTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.leading,
      this.trailing = Icons.arrow_forward_ios,
      required this.onTap});
  final String title;
  final String? subtitle;
  final IconData? leading;
  final IconData? trailing;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onTap();
        },
        title: MediumText(text: title),
        leading: BuildIcon(
          icon: leading!,
          size: 25,
        ),
        trailing: BuildIcon(
          icon: trailing!,
          size: 16,
        ));
  }
}
