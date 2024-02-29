import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/utils/Notifier.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/networkAPI.dart';
import '../model/userModel.dart';
import '../resources/appURL.dart';
import '../utils/constraints.dart';
import '../utils/topLevelFunction.dart';
import '../utils/utils.dart';

class SignUpViewModel extends GetxController {
  late TextEditingController passwordController;
  late TextEditingController emailController;
  late FocusNode passwordsNode;
  late TextEditingController nameController;
  late FocusNode phoneNode;
  late TextEditingController phoneController;
  late FocusNode nameNode;
  late FocusNode emailNode;
  TextEditingController otpConroller = TextEditingController();
  bool isVerified = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  initFields() {
    passwordsNode = FocusNode();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailNode = FocusNode();
    nameController = TextEditingController();
    nameNode = FocusNode();
    phoneController = TextEditingController();
    phoneNode = FocusNode();
  }

  disposeFields() {
    emailController.dispose();
    passwordController.dispose();
    passwordsNode.dispose();
    emailNode.dispose();
    nameController.dispose();
    nameNode.dispose();
  }

  handleSubmit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        await sendVerificationRequest();
      } catch (e) {
        Utils.printMessage(e.toString());
        Utils().showSnackBar(e.toString(), context, isSuccess: true);
      }
    } else {
      Utils().showSnackBar("Fill out all fields", context);
    }
  }

  Future<void> sendVerificationRequest() async {
    emailController.text = "devrajstha88@gmail.com";
    nameController.text = "devraj shrestha";
    try {
      Map<String, dynamic> data = {
        "sessionKey": nameController.text.split('')[0],
        "mailTo": emailController.text
      };
      final res = await NetworkAPI().postRequest(AppURL.sentOTP, data);
      final status = res['status'];
      final message = res['message'];
      if (status) {
        Utils.toastMessage(message, isSuccess: true);
        isVerified = true;
      } else {
        Utils.toastMessage(message);
      }
    } catch (e) {
      Utils.toastMessage("Exception: $e");
    }
  }

  Future<void> veryfyAccount(BuildContext context) async {
    try {
      Map<String, dynamic> data = {
        "sessionKey": nameController.text.split('')[0],
        "otp": otpConroller.text,
        "email": emailController.text
      };
      final res = await NetworkAPI().postRequest(AppURL.verifyOTP, data);
      final status = res['status'];
      final message = res['message'];
      if (status) {
        Utils.toastMessage(message, isSuccess: true);
        isVerified = true;
        await submitData(context);
      } else {
        Utils.toastMessage(message);
      }
    } catch (e) {
      Utils.toastMessage("Exception: $e");
    }
  }

  Future<void> submitData(BuildContext context) async {
    FirebaseMessage m = FirebaseMessage();
    final token = await m.getToken();

    Map<String, dynamic> data = {
      "email": emailController.text,
      "password": passwordController.text,
      "name": nameController.text,
      "phone": phoneController.text,
      "phoneToken": token
    };
    final res = await NetworkAPI().postRequest(AppURL.signUpURL, data);
    String status = res['status'];
    String message = res['message'];
    Utils.printMessage(res.toString());
    if (status.toLowerCase() == "success") {
      final data = res['data'];
      Users u = Users.fromJson(data);
      Utils.toastMessage(message, isSuccess: true);
      final sp = await SharedPreferences.getInstance();
      Navigator.pushNamed(context, RoutesName.Home);
      dbController.insertUser(u).then((value) {
        print(value);
      }).onError((error, stackTrace) {
        Utils.printMessage(error.toString());
      });
      sp.setBool(Constrains.LOGINKEY, true);

      Utils.toastMessage(message, isSuccess: true);
    } else {
      Utils.printMessage(message);
      Utils.toastMessage(message);
    }
  }
}
