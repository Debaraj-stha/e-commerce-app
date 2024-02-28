import 'package:flutter/material.dart';
import 'package:frontend/model-view/home-view.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/boldText.dart';
import 'package:frontend/resources/components/cardProduct.dart';
import 'package:get/get.dart';

import 's.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({super.key});

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  final HomeModelView _homeview = Get.find<HomeModelView>();
  // final RefreshController _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BoldText(
          text: "Recommended",
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

          return Column(
            children: [
              const SizedBox(
                height: 10,
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
                    final products = _homeview.recommendations[index];
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
                  itemCount: _homeview.recommendations.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true, // Add this line
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
