import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:frontend/data/network/networkAPI.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/resources/appURL.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../model/orderModel.dart';
import '../utils/topLevelFunction.dart';

class OrderModel extends GetxController {
  RxList<Order> order = <Order>[].obs;
  void handleOrder(List<Order> order) {
    order.addAll(order);

    print(order[0].rate);
    // Order order=Order(userId: userId, productId: productId, payment: paymentMethod, rate: rate, quantity: quantiy);
    update();
  }

  void setPaymentMethod(String paymentMethod, BuildContext context,
      List<MyCartModel> model) async {
    order[0].payment = paymentMethod;
    final List<Map<String, dynamic>> orderData = [];
    for (var i = 0; i < order.length; i++) {
      final x = order[i].toJson();
      final data = {
        "quantity": x['quantity'],
        "payment": x['payment'],
        "productId": x['productId'],
        "userId": x['userId'],
      };
      orderData.add(data);
    }
    print("c$orderData");
    try {
      final data = {"data": jsonEncode(orderData)};
      final res = await NetworkAPI().postRequest(AppURL.orderProduct, data);
      print("res$res");
      String status = res['status'];
      int orderId = res['orderId'];
      print("$orderId orderd");
      Utils.printMessage("order id: $orderId");
      if (status.toLowerCase() == "success") {
        model.forEach((ele) async {
          print("ele ${ele.toJson()}");
          ele.cart.id = orderId;
          await insertOrder(ele);
        });
        Utils().showSnackBar(res['message'], context);
      } else {
        Utils().showSnackBar(res['message'], context, isSuccess: false);
      }
    } catch (e) {
      print(e);
      Utils().showSnackBar(e.toString(), context, isSuccess: false);
    }

    update();
  }
}
