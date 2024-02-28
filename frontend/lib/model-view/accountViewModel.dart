import 'package:flutter/material.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/model/userModel.dart';
import 'package:frontend/utils/handleTheme.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class AccountViewModel extends GetxController {
  final RxString _selectedTheme = RxString("dark");
  final RxString _selectedLanguage = RxString("english");
  RxString get selectedTheme => _selectedTheme;
  RxString get selectedLamguage => _selectedLanguage;
  RxList<MyCartModel> myPurchaqse = RxList<MyCartModel>();
  RxList<MyCartModel> myOrder = RxList<MyCartModel>();
  final RxList<Users> _user = RxList();
  RxList<Users> get user => _user;
  RxBool isLOading = RxBool(true);
  final Utils _utils = Utils();
  void handleThemeChange(String themeValue) {
    _selectedTheme.value = themeValue;

    HandleTheme().changeTheme(themeValue);
    print(themeValue);
    update();
  }

  void handleLanguageChange(String languageValue) {
    _selectedLanguage.value = languageValue;
    Utils.printMessage(languageValue);
    update();
  }

  handleListTileTap(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  Future<void> getUserDetails(BuildContext context) async {
    try {
      await dbController.getUser().then((value) {
        _user.value = value;
      }).onError((error, stackTrace) {
        Utils().showSnackBar("error$error", context);
        throw error.toString();
      });
      print("_user ${user[0].name}");

      update();
    } catch (e) {
      Utils.printMessage(e.toString());
      final x = e.toString().split(":");
      if (x[0] != "RangeError (index)") {
        Utils().showSnackBar("e$e", context);
      }
    }
  }

  Future<void> getPurchaseData() async {
    await Future.delayed(const Duration(seconds: 2));
    isLOading.value = false;
    await dbController.getMyPurchase().then((value) {
      myPurchaqse.addAll(value);
      update();
    });
  }

  Future<void> getMyOrder() async {
    await Future.delayed(const Duration(seconds: 2));
    isLOading.value = false;
    await dbController.getMyOrders().then((value) {
      myPurchaqse.addAll(value);
      update();
    });
  }
}
