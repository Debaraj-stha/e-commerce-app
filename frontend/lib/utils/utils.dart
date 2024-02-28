import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/data/network/networkAPI.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/appURL.dart';
import 'package:get/get.dart';

import 'constraints.dart';

class Utils extends GetxController {
  static RegExp emailReg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp passRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static RegExp nameRegExp = RegExp('[a-zA-Z]');
  static RegExp phoneReg = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  static final TextEditingController searchController = TextEditingController();
  static FocusNode searchNode = FocusNode();
  RxInt currentIndex = RxInt(0);
  bool isLoading = false;
  Map<String, int> productCout = {};
  int getProductCount(int itemId) => productCout[itemId] ?? 1;
  RxBool isobsecure = RxBool(true);
  Map<String, int> orderState = {};
  RxBool isProgress = RxBool(false);
  Map progressMap = {};
  Map addToCartProgress = {};
  bool getItemProgress(String key) => progressMap[key] ?? false;
  bool getAddToCartProgress(String key) => addToCartProgress[key] ?? false;
  int getOrderState(String orderId) => orderState[orderId] ?? 1;
  void handleTap(int val) {
    currentIndex.value = val;
    printMessage(val.toString());
    update();
  }

  showSnackBar(String text, BuildContext context, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: isSuccess ? Colors.black : Colors.white),
      ),
      showCloseIcon: true,
      padding: const EdgeInsets.all(8),
      closeIconColor: Colors.black,
      duration: const Duration(seconds: 3),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    ));
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static validator(String value, int type) {
    if (value.isEmpty) {
      return "this value is required";
    } else {
      switch (type) {
        case 1:
          if (emailReg.hasMatch(value)) {
            return null;
          } else {
            return "Invalid email format..Please try again";
          }
        case 2:
          if (passRegex.hasMatch(value)) {
            return null;
          } else {
            return "Invalid password format.Please choose strong password";
          }
        case 3:
          if (nameRegExp.hasMatch(value)) {
            return null;
          } else {
            return "Invalid name format.Please try again";
          }
        case 4:
          if (phoneReg.hasMatch(value)) {
            return null;
          } else {
            return "Invalid phone number.Please enter valid phone andtry again";
          }
        default:
      }
      return null;
    }
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static void printMessage(String data) {
    if (kDebugMode) {
      print(data.toString());
    }
  }

  static void handleFocusNode(
      FocusNode current, FocusNode? next, BuildContext context) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static void onChanged(String val) {
    printMessage("changed val$val");
  }

  static void onSubmited(String val) {
    printMessage("Submitted val$val");
  }

  void disposeFields() {
    searchController.dispose();
    searchNode.dispose();
  }

  void incrementDecrement(
      String itemId, int oldCount, int type, BuildContext context) {
    if (!productCout.containsKey(itemId)) {
      productCout[itemId] = oldCount;
      print(productCout.containsKey(itemId));
    } else {
      print("inside else ");
      switch (type) {
        case 0:
          if (oldCount > 5) {
            Utils().showSnackBar("You can't order more than 5", context);
          } else {
            productCout[itemId] = oldCount + 1;
          }

        case 1:
          if (oldCount < 1) {
            Utils().showSnackBar("You can't order less than 1", context);
          } else {
            productCout[itemId] = oldCount - 1;
          }
      }
    }
    Utils.printMessage(productCout.toString());
  }

  togglePassword() {
    isobsecure.value = !isobsecure.value;
    update();
  }

  Timer? timer;
  startTimer(FocusNode focusNode) {
    timer = Timer(const Duration(seconds: 6), () {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
        print("unfocus");
      }
    });
    print("start");
    update();
  }

  cancelTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      print("cancel");
    }
    update();
  }

  handleOrderState(String orderId, int state) {
    orderState[orderId] = state;
    update();
  }

  int getActiveId(String status) {
    switch (status) {
      case ORDER_STATUS.PENDING:
        return 1;

      case ORDER_STATUS.CANCEL:
        return 2;

      case ORDER_STATUS.ONTHEWAY:
        return 3;

      case ORDER_STATUS.DELIVERED:
        return 4;
      default:
        return 0;
    }
  }

  bool isFade = false;
  FocusNode focusNode = FocusNode();
  TextEditingController reviewController = TextEditingController();
  handleTapOutside() {
    focusNode.unfocus();
  }

  submitReview() {}

  toggleFade() {
    isFade = !isFade;
    update();
  }

  double ratingValue = 2;
  void handleRating(double value) {
    ratingValue = value;
    update();
  }

  void postReview(String productId, BuildContext context) async {
    try {
      String userId = "2";
      String feedback = reviewController.text;
      Map<String, dynamic> data = {
        "userId": userId,
        "feedback": feedback,
        "productId": productId,
        "rating": ratingValue.toString()
      };

      final res = await NetworkAPI().postRequest(AppURL.reviewAdd, data);
      String status = res['status'];
      String meg = res['message'];

      if (status.toLowerCase() == 'success') {
        showSnackBar(meg, context);
      } else {
        showSnackBar(meg, context, isSuccess: false);
      }
    } catch (e) {
      Utils().showSnackBar(e.toString(), context, isSuccess: false);
      printMessage(e.toString());
    }
  }

  static void toastMessage(String message, {isSuccess = false}) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: isSuccess ? AppColors.primary : Colors.red);
  }

  void toggleProgress(String key) async {
    isProgress.value = true;
    progressMap[key] = true;
    update();
    await Future.delayed(const Duration(seconds: 2));
    isProgress.value = false;
    progressMap[key] = false;
    update();
  }

  void toggleAddToCArtButton(String key) async {
    isProgress.value = true;
    addToCartProgress[key] = true;
    update();
    await Future.delayed(const Duration(seconds: 2));
    isProgress.value = false;
    addToCartProgress[key] = false;
    update();
  }
}
