import 'package:flutter/material.dart';

class BuildIcon extends StatelessWidget {
  const BuildIcon(
      {super.key,
      required this.icon,
      this.iconColor = Colors.black,
      this.bgColor = Colors.transparent,
      this.size = 30});
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: Icon(
        icon,
        size: size,
      ),
    );
  }
}
