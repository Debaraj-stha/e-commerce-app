import 'package:flutter/material.dart';
import 'package:frontend/model-view/home-view.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import 'buildHeading.dart';
import 'cardProduct.dart';

class Category extends StatefulWidget {
  const Category({super.key, required this.products});
  final products;
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
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
            Navigator.pushNamed(context, RoutesName.CATEGORYPAGE);
          },
          child: Row(
            children: [
              const BuildHeading(
                text: "Category",
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
        SizedBox(
          width: Utils.getWidth(context),
          height: Utils.getHeight(context) * 0.33,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return InkWell(
                  onTap: () {
                    _h.loadCategoryProduct(
                        context, widget.products[index].category);
                  },
                  child: ProductCard(
                    product: product,
                    isCategory: true,
                  ));
            },
            scrollDirection: Axis.horizontal,
            itemCount: widget.products.length,
            // shrinkWrap: true,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
          ),
        ),
      ],
    );
  }
}
