import 'package:flutter/material.dart';
import 'package:frontend/utils/Notifier.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/networkAPI.dart';
import '../model/userModel.dart';
import '../resources/appURL.dart';
import '../utils/constraints.dart';
import '../utils/routes/routeName.dart';
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
    FirebaseMessage m = FirebaseMessage();
    if (formKey.currentState!.validate()) {
      final token = await m.getToken();
      Map<String, dynamic> data = {
        "email": emailController.text,
        "password": passwordController.text,
        "name": nameController.text,
        "phone": phoneController.text,
        "phoneToken": token
      };
      try {
        final res = await NetworkAPI().postRequest(AppURL.signUpURL, data);
        String status = res['status'];
        String message = res['message'];
        Utils.printMessage(res.toString());
        if (status.toLowerCase() == "success") {
          final data = res['data'];
          Users u = Users.fromJson(data);
          Utils().showSnackBar(message, context, isSuccess: true);
          final sp = await SharedPreferences.getInstance();

          dbController.insertUser(u).then((value) {
            print(value);
          }).onError((error, stackTrace) {
            Utils.printMessage(error.toString());
          });
          sp.setBool(Constrains.LOGINKEY, true);
          Navigator.pushNamed(context, RoutesName.Home);
          Utils().showSnackBar(message, context);
        }
        Utils.printMessage(message);
        Utils().showSnackBar(message, context, isSuccess: true);
      } catch (e) {
        Utils.printMessage(e.toString());
        Utils().showSnackBar(e.toString(), context, isSuccess: true);
      }
    } else {
      Utils().showSnackBar("Fill out all fields", context);
    }
  }
}
