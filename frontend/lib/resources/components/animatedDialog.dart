import 'package:flutter/material.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/animationPromt.dart';

class AnimatedDialog extends StatelessWidget {
  const AnimatedDialog(
      {super.key, required this.title, this.subtitle, required this.child});
  final Widget child;
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.third,
      body: SafeArea(
        child: Center(
          child: AnimationPromt(
              title: title, subTitle: subtitle ?? "", child: child),
        ),
      ),
    );
  }
}
