import 'package:flutter/material.dart';

import 'buildHeading.dart';
import 'cardProduct.dart';

class SimilarProducts extends StatelessWidget {
  const SimilarProducts({super.key, required this.products});
  final products;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            BuildHeading(
              text: "Similar Products",
            ),
            Icon(Icons.arrow_right_alt)
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 260,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true, // Add this line
          ),
        ),
      ],
    );
  }
}
