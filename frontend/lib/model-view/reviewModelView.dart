import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/network/networkAPI.dart';
import 'package:frontend/model/reviewModels.dart';
import 'package:frontend/resources/appURL.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class ReviewModelView extends GetxController {
  RxList<Reviews> reviews = <Reviews>[].obs;
  RxMap<int, bool> isShowTextBox = <int, bool>{}.obs;
  TextEditingController reviewController = TextEditingController();
  FocusNode focusNode = FocusNode();
  RxBool isLoading = RxBool(true);
  bool isShown(int id) => isShowTextBox[id] ?? false;

  toggleIsShown(int id, String previousF) {
    if (isShowTextBox[id] == true) {
      isShowTextBox[id] = false;
    } else {
      isShowTextBox.updateAll((key, value) => false);
      isShowTextBox[id] = true;
      reviewController.text = previousF;
    }
    print(isShowTextBox);
    update();
  }

  Future<void> loadReviews(int userId, BuildContext context) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;
      String url = "${AppURL.getUserReviews}?userId=$userId";
      final res = await NetworkAPI().getRequest(url);
      String status = res['status'];
      String message = res['message'];
      if (status.toLowerCase() == "success") {
        final datas = res['data'];

        for (var data in datas) {
          Utils.printMessage(data.toString());
          reviews.add(Reviews.fromJson(data));
        }
        Utils.printMessage(reviews.toString());
        Utils().showSnackBar(message, context);
        update();
      } else {
        Utils().showSnackBar(message, context, isSuccess: false);
      }
    } catch (e) {
      Utils.printMessage("Exception $e");
    }
  }

  Future<void> updateReview(int reviewId, BuildContext context) async {
    try {
      Map<String, dynamic> data = {
        "feedback": reviewController.text,
        "reviewId": reviewId.toString()
      };
      final res = await NetworkAPI().postRequest(AppURL.editReview, data);
      String status = res['status'];
      String message = res['message'];
      if (status.toLowerCase() == 'message') {
        Utils().showSnackBar(message, context, isSuccess: true);
      } else {
        Utils().showSnackBar(message, context);
      }
    } catch (e) {
      Utils.printMessage("Exception $e");
    }
    print("called");
  }
}
