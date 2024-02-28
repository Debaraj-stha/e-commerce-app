import 'package:flutter/material.dart';
import 'package:frontend/model-view/home-view.dart';
import 'package:get/get.dart';

import '../../view/s.dart';
import '../resources/components/buildHeading.dart';
import '../resources/components/cardProduct.dart';

class CategoryProduct extends StatefulWidget {
  const CategoryProduct({super.key});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  final HomeModelView _home = Get.find<HomeModelView>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BuildHeading(
            text: _home.category[0].category,
          ),
        ),
        body: Obx(() => SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                            product: _home.category[index])));
                              },
                              child:
                                  ProductCard(product: _home.category[index]));
                        },
                        scrollDirection: Axis.vertical,
                        itemCount: _home.category.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true, // Add this line
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
