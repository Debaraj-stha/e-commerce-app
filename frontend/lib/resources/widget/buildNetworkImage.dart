import 'package:flutter/material.dart';

Widget BuildNetworkImage(String image,
    {double width = 70, double height = 90}) {
  return SizedBox(
    width: width,
    height: height,
    child: Image(
      image: NetworkImage(image),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Image(image: AssetImage("asset/images/image5.jpeg"));
      },
    ),
  );
}
