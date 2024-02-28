import 'package:flutter/material.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/model/orderModel.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../../model-view/ordre.dart';
import '../appColors.dart';

khaltiPay(BuildContext context) {
  PaymentConfig config = PaymentConfig(
      amount: 20 * 100, productIdentity: "3322", productName: "product name");
  void onSuccess(PaymentSuccessModel model) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Payment successful"),
              actions: [
                SimpleDialogOption(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  void onFailure(PaymentFailureModel failure) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Payment Failure"),
              actions: [
                SimpleDialogOption(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  KhaltiScope.of(context).pay(
    config: config,
    onSuccess: onSuccess,
    onFailure: onFailure,
    preferences: [
      PaymentPreference.khalti,
      PaymentPreference.connectIPS,
      PaymentPreference.mobileBanking
    ],
    onCancel: onCancel(context),
  );
}

onCancel(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Payment Failure"),
            actions: [
              SimpleDialogOption(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
}

showPayMentDialog(BuildContext context, List<MyCartModel> model) {
  OrderModel _o = Get.find<OrderModel>();
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      surfaceTintColor: Colors.blue,
      backgroundColor: Colors.black,
      title: Text("Payment Options",
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .primaryTextTheme
              .bodyLarge!
              .copyWith(color: AppColors.secondary)),
      content: Container(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildButton("Pay with Khalti", () {
              khaltiPay(context);
              _o.setPaymentMethod(PaymentMethod.KHALTI, context, model);
            }, context),
            BuildButton("Cash on delivery", () {
              _o.setPaymentMethod(PaymentMethod.CASH, context, model);
            }, context),
            BuildButton("Pay with Esewa", () {
              OrderModel()
                  .setPaymentMethod(PaymentMethod.ESEWA, context, model);
            }, context),
          ],
        ),
      ),
      actions: [
        TextButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Close",
              style: Theme.of(context)
                  .primaryTextTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            )),
      ],
    ),
  );
}

Widget BuildButton(String title, VoidCallback callback, BuildContext context) {
  return Center(
    child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        callback();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          title,
          style: Theme.of(context)
              .primaryTextTheme
              .bodyMedium!
              .copyWith(color: AppColors.third),
        ),
      ),
    ),
  );
}
