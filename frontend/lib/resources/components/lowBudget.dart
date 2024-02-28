import 'package:flutter/material.dart';
import 'package:frontend/model-view/home-view.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:get/get.dart';

import '../../view/s.dart';
import 'buildHeading.dart';
import 'cardProduct.dart';

class LowBudget extends StatefulWidget {
  const LowBudget({super.key, required this.products});
  final products;
  @override
  State<LowBudget> createState() => _LowBudgetState();
}

class _LowBudgetState extends State<LowBudget> {
  final HomeModelView _h = Get.find<HomeModelView>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.LOWBUDGETPAGE);
          },
          child: const Row(children: [
            BuildHeading(
              text: "Low Budget",
            ),
            Icon(Icons.arrow_right_alt)
          ]),
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
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleProduct(
                                product: widget.products[index])));
                  },
                  child: ProductCard(product: widget.products[index]));
            },
            scrollDirection: Axis.vertical,
            itemCount: widget.products.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true, // Add this line
          ),
        ),
      ],
    );
  }
}
