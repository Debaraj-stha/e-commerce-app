import 'package:flutter/material.dart';
import 'package:frontend/data/network/networkAPI.dart';
import 'package:frontend/model/userModel.dart';
import 'package:frontend/resources/appURL.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModelView extends GetxController {
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late FocusNode passwordsNode;
  late FocusNode emailNode;
  Users? user;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  initFields() {
    passwordsNode = FocusNode();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailNode = FocusNode();
  }

  disposeFields() {
    emailController.dispose();
    passwordController.dispose();
    passwordsNode.dispose();
    emailNode.dispose();
  }

  handleSubmit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "email": emailController.text,
        "password": passwordController.text
      };
      try {
        final res = await NetworkAPI().postRequest(AppURL.loginUrl, data);
        String status = res['status'];
        String message = res['message'];
        Utils.printMessage(res.toString());
        if (status.toLowerCase() == "success") {
          final data = res['data'];
          Users u = Users.fromJson(data);
          print(data);
          Utils().showSnackBar(message, context, isSuccess: true);
          final sp = await SharedPreferences.getInstance();
          try {
            bool userInserted = await dbController.insertUser(u);
            if (!userInserted) {
              Utils.printMessage('Failed to insert user');
            }
          } catch (e) {
            Utils.printMessage('Error inserting user: $e');
          }
          sp.setBool(Constrains.LOGINKEY, true);
          Navigator.pushNamed(context, RoutesName.Home);
          Utils().showSnackBar(message, context);
        } else {
          Utils.printMessage(message);
          Utils().showSnackBar(message, context, isSuccess: true);
        }
      } catch (e) {
        Utils().showSnackBar(e.toString(), context, isSuccess: true);
      }
    } else {
      Utils().showSnackBar("Fill out all fields", context);
    }
  }

  Future<void> login() async {
    Map data = {
      "email": emailController.text,
      "password": passwordController.text
    };
    String url = AppURL.loginUrl;
    final res = await NetworkAPI().postRequest(url, data);
    Utils.printMessage(res);
    user = Users.fromJson(res);
  }
}
