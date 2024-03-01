import 'package:flutter/material.dart';
import 'package:frontend/model-view/home-view.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/boldText.dart';
import 'package:frontend/resources/components/cardProduct.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'singleItem.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final HomeModelView _homeview = Get.find<HomeModelView>();
  final RefreshController _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BoldText(
          text: "Category",
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (_homeview.isLoading.isTrue) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primary,
            ));
          }

          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () {
              Utils.printMessage("Refreshing");
            },
            onLoading: () async {
              await _homeview.loadMoreData(2, context);
            },
            controller: _refreshController,
            child: ListView(
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
                      final products = _homeview.category[index];
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleProduct(product: products)));
                          },
                          child: ProductCard(
                            product: products,
                            isCartIcon: false,
                            isWishlistIcon: false,
                            isCategory: true,
                          ));
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: _homeview.category.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true, // Add this line
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
