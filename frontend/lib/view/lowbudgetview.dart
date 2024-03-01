import 'package:flutter/material.dart';
import 'package:frontend/model-view/home-view.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/boldText.dart';
import 'package:frontend/resources/components/cardProduct.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'singleItem.dart';

class LowBudgetProduct extends StatefulWidget {
  const LowBudgetProduct({super.key});

  @override
  State<LowBudgetProduct> createState() => _LowBudgetProductState();
}

class _LowBudgetProductState extends State<LowBudgetProduct> {
  final HomeModelView _homeview = Get.find<HomeModelView>();
  final RefreshController _controller = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.loading);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BoldText(
          text: "Low Budget",
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
            controller: _controller,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () {},
            onLoading: () async {
              await _homeview.loadMoreData(3, context);
            },
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
                      final products = _homeview.lowBudget[index];
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleProduct(product: products)));
                          },
                          child: ProductCard(product: products));
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: _homeview.lowBudget.length,
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
