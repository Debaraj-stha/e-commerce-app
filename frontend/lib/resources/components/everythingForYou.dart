import 'package:flutter/material.dart';

import 'buildHeading.dart';
import 'cardProduct.dart';
import 'productCard.dart';

class EveryThinForYou extends StatelessWidget {
  const EveryThinForYou({Key? key, required this.products}) : super(key: key);
  final products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {},
          child: const Row(
            children: [
              BuildHeading(
                text: "Just For You",
              ),
              Icon(Icons.arrow_right_alt)
            ],
          ),
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
