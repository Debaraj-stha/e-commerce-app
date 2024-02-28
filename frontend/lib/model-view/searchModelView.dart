import 'package:flutter/widgets.dart';
import 'package:frontend/model/productModel.dart';
import 'package:frontend/resources/appURL.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../data/network/networkAPI.dart';
import '../model/searchModel.dart';

class SearchModeView extends GetxController {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  RxList<SearchProduct> search = <SearchProduct>[].obs;
  Products? product;
  void handleChange(String query, BuildContext context) async {
    try {
      if (query.trim().isNotEmpty) {
        String queryToLower = query.toLowerCase();
        String url = "${AppURL.searchURL}?q=$queryToLower";
        final res = await NetworkAPI().getRequest(url);
        final String status = res['status'];
        if (status.toLowerCase() == 'success') {
          final datas = res['data'];
          search.clear();

          for (var data in datas) {
            search.add(SearchProduct.fromJson(data));
            print(data['title']);
          }
          update();
        } else {
          String msg = res['message'];
          Utils.printMessage(msg);
          Utils().showSnackBar(msg, context, isSuccess: false);
        }
      } else {
        search.clear();
        // update();
      }
    } catch (e) {
      Utils.printMessage("exception $e");
      Utils().showSnackBar(e.toString(), context, isSuccess: false);
    }
  }

  void handleSubmit(value) {
    focusNode.unfocus();
    controller.clear();
  }

  Future<void> getSpecificProduct(int productId) async {
    try {
      String url = "${AppURL.getSingeProduct}?productId=$productId";
      print("is $productId");
      final res = await NetworkAPI().getRequest(url);
      final data = res['data'][0];

      product = Products.fromJson(data);
      print(product);
      update();
    } catch (e) {}
  }
}
