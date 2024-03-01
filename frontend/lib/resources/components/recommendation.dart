import 'package:flutter/material.dart';
import 'package:frontend/model-view/home-view.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:frontend/view/singleItem.dart';
import 'package:get/get.dart';

import 'buildHeading.dart';
import 'cardProduct.dart';

class Recommended extends StatefulWidget {
  const Recommended({super.key, required this.products});
  final products;
  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
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
            Navigator.pushNamed(context, RoutesName.RECOMMENDEDPAGE);
          },
          child: Row(
            children: [
              const BuildHeading(
                text: "Recommended",
              ),
              Icon(
                Icons.arrow_right_alt,
                color: AppColors.primary,
              )
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
