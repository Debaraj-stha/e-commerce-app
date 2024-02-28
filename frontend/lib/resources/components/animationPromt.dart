import 'package:flutter/material.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/utils/utils.dart';

class AnimationPromt extends StatefulWidget {
  const AnimationPromt(
      {super.key,
      this.child,
      required this.title,
      this.subTitle,
      this.iconBg = Colors.green});
  final Widget? child;
  final String? subTitle;
  final String title;
  final Color? iconBg;
  @override
  State<AnimationPromt> createState() => _AnimationPromtState();
}

class _AnimationPromtState extends State<AnimationPromt>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation, _containerAnimation;
  late Animation<Offset> _yAnimation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _iconAnimation = Tween<double>(begin: 7, end: 6)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _containerAnimation =
        Tween<double>(begin: 2, end: 0.4).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
    _yAnimation = Tween<Offset>(
            begin: const Offset(0, 0), end: const Offset(0, -0.23))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.reset();
    _controller.forward();
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: BoxConstraints(
            minHeight: Utils.getHeight(context) * 0.4,
            maxHeight: Utils.getHeight(context) * 0.8,
            minWidth: Utils.getHeight(context) * 0.4,
            maxWidth: Utils.getWidth(context) * 0.8),
        decoration: BoxDecoration(
            color: AppColors.primary, borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                      color: AppColors.textColorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.subTitle ?? "",
                  style: TextStyle(
                      color: AppColors.textColorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned.fill(
                child: SlideTransition(
              position: _yAnimation,
              child: ScaleTransition(
                scale: _containerAnimation,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: widget.iconBg),
                  child: ScaleTransition(
                    scale: _iconAnimation,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: widget.child),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
