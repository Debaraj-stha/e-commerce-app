import 'package:flutter/material.dart';
import 'package:frontend/model-view/searchModelView.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/category.dart';
import 'package:frontend/resources/components/lowBudget.dart';
import 'package:frontend/resources/components/recommendation.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/view/searchView.dart';
import 'package:get/get.dart';

import '../model-view/home-view.dart';
import '../resources/widget/buildSearchBar.dart';
import '../utils/topLevelFunction.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final Utils _utils = Utils();
  final HomeModelView _homeView = Get.find<HomeModelView>();
  final SearchModeView _s = Get.find<SearchModeView>();
  @override
  void initState() {
    super.initState();
    getRecommendet(context);
    getCategory(context);
    getLowBudget(context);

    // _homeView.loadCategory(context);
    // _homeView.loadRecommendedData(context);
    // _homeView.loadLowBudgetData(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Obx(
          () => Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Column(
                children: [
                  BuildSearchBar("Search here...", context),
                  if (_homeView.isLoading.isTrue) ...[
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: Utils.getHeight(context) * 0.4),
                        child:
                            CircularProgressIndicator(color: AppColors.primary))
                  ],
                  if (_homeView.isLoading.isFalse) ...[
                    Category(products: _homeView.category),
                    Text(_homeView.recommendations.length.toString()),
                    Recommended(products: _homeView.recommendations),
                    LowBudget(products: _homeView.lowBudget),
                  ]
                ],
              ),
              _s.search.isNotEmpty ? const SearchView() : Container(),
            ],
          ),
        ));
  }
}
