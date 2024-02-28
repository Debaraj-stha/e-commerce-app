import 'package:flutter/material.dart';
import 'package:frontend/data/network/networkAPI.dart';
import 'package:frontend/model/messageModel.dart';
import 'package:frontend/resources/appURL.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class MessageViewMOdel extends GetxController {
  final RxList<Message> _messages = <Message>[].obs;
  RxList<Message> get messages => _messages;
  TextEditingController textEditingController = TextEditingController();
  RxBool isLoading = RxBool(false);
  FocusNode focusNode = FocusNode();
  final RxList<Message> _specifcShopMessage = <Message>[].obs;
  RxList<Message> get shopMessage => _specifcShopMessage;
  Future<void> getMyMessages(String userId) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
      String url = "${AppURL.getMessage}?userId=$userId";
      final res = await NetworkAPI().getRequest(url);
      bool status = res['status'];
      String message = res['message'];
      if (status) {
        final data = res['data'];
        for (var obj in data) {
          print("data: $obj");
          _messages.add(Message.fromJson(obj));
        }

        update();
      } else {
        Utils.toastMessage(message);
      }
    } catch (e) {
      Utils.printMessage(e.toString());
    }
  }

  handleChange(String message, Utils u) {
    u.cancelTimer();
    u.startTimer(focusNode);
  }

  handleSubmit() {}

  Future<void> getMyMessage(int shopId, int userId) async {
    print("Called");
    try {
      // isLoading.value = true;
      // await Future.delayed(const Duration(seconds: 1));
      // isLoading.value = false;
      String url =
          "${AppURL.getSingleShopMessage}?userId=$userId&shopId=$shopId&";
      final res = await NetworkAPI().getRequest(url);
      bool status = res['status'];
      String message = res['message'];
      if (status) {
        final data = res['data'];
        for (var obj in data) {
          print("data: $obj");
          _specifcShopMessage.add(Message.fromJson(obj));
        }
        print(_messages.toJson());
      } else {
        Utils.toastMessage(message);
      }
    } catch (e) {
      Utils.printMessage(e.toString());
    }
  }
}
