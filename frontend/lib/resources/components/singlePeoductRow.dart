import 'package:flutter/material.dart';

import 'package:frontend/resources/components/mediumText.dart';

class SingleProductRow extends StatelessWidget {
  const SingleProductRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      // margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(),
            child: const Icon(
              Icons.image,
              color: Colors.red,
            ),
          ),
          const Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediumText(
                text: "Title of the product",
              ),
              MediumText(
                text: "Rs :190",
              ),
              MediumText(
                text: "Quantity:16",
              )
            ],
          ))
        ],
      ),
    );
  }
}
