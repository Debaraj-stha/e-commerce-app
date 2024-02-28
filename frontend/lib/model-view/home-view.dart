import 'package:flutter/material.dart';
import 'package:frontend/data/network/networkAPI.dart';
import 'package:frontend/model/productModel.dart';
import 'package:frontend/resources/appURL.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../utils/topLevelFunction.dart';

class HomeModelView extends GetxController {
  final RxList<Products> _category = <Products>[].obs;
  RxList<Products> get category => _category;
  final RxList<Products> _recommendations = <Products>[].obs;
  RxList<Products> get recommendations => _recommendations;
  final RxList<Products> _lowBudget = <Products>[].obs;
  RxList<Products> get lowBudget => _lowBudget;
  RxList<Products> justForYou = <Products>[].obs;
  RxList<Products> categoryProduct = <Products>[].obs;
  RxBool isLoading = RxBool(true);
  Map<String, dynamic> currentItemLimitOffset = {};
  Future<void> loadCategory(BuildContext context, dynamic res) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (_category.isEmpty) {
        String status = res['status'];

        if (status.toLowerCase() == 'success') {
          final data = res['data'];

          for (var x in data) {
            category.add(Products.fromJson(x));
          }
        }
        isLoading.value = false;
        currentItemLimitOffset['2'] = category.length;
        update();
      }
    } catch (e) {
      Utils().showSnackBar(e.toString(), context, isSuccess: false);
    }
  }

  Future<void> loadRecommendedData(BuildContext context, dynamic res) async {
    try {
      if (_recommendations.isEmpty) {
        await Future.delayed(const Duration(seconds: 2));
        String status = res['status'];
        if (status.toLowerCase() == 'success') {
          final data = res['data'];
          for (var x in data) {
            _recommendations.add(Products.fromJson(x));
          }
        }
        isLoading.value = false;
        currentItemLimitOffset['1'] = recommendations.length;
        update();
      }
    } catch (e) {
      print(e.toString());
      Utils().showSnackBar(e.toString(), context, isSuccess: false);
    }
  }

  Future<void> loadLowBudgetData(BuildContext context, dynamic res) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      String status = res['status'];

      if (status.toLowerCase() == 'success') {
        final data = res['data'];

        for (var x in data) {
          _lowBudget.add(Products.fromJson(x));
        }
      }
      isLoading.value = false;
      currentItemLimitOffset['3'] = lowBudget.length;
      update();
      // }
    } catch (e) {
      Utils().showSnackBar(e.toString(), context, isSuccess: false);
    }
  }

  Future<void> loadCategoryProduct(BuildContext context, String cat) async {
    Navigator.pushNamed(context, RoutesName.CATEGORYPRODUCT);
    try {
      // if(_lowBudget.isEmpty){
      String url = "${AppURL.productCategory}?category=$cat";
      final res = await NetworkAPI().getRequest(url);
      String status = res['status'];

      if (status.toLowerCase() == 'success') {
        final data = res['data'];

        for (var x in data) {
          categoryProduct.add(Products.fromJson(x));
        }
      }
      update();
      // }
    } catch (e) {
      Utils().showSnackBar(e.toString(), context, isSuccess: false);
    }
  }

  Future<void> loadMoreData(int type, BuildContext context) async {
//type  =1 for  recommended item,type =2 for category and type =3 for  lowbudget

    switch (type) {
      case 1:
        final currentOffset = currentItemLimitOffset['1'];
        await getRecommendet(context, isLoadMore: true, offset: currentOffset);
        break;
      case 2:
        final currentOffset = currentItemLimitOffset['2'];
        await getCategory(context, isLoadMore: true, offset: currentOffset);
        break;

      case 3:
        final currentOffset = currentItemLimitOffset['3'];
        await getLowBudget(context, isLoadMore: true, offset: currentOffset);
    }
  }
}
