import 'package:flutter/material.dart';

import '../appColors.dart';
import '../components/smallText.dart';

Widget BuildBadge(IconData icon, int value) {
  return Stack(children: [
    Icon(icon),
    value > 0
        ? Positioned(
            child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: SmallText(
                  text: value.toString(),
                  color: AppColors.textColorPrimary,
                )))
        : const SizedBox()
  ]);
}
