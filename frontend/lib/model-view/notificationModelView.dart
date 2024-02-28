import 'package:frontend/data/network/networkAPI.dart';
import 'package:frontend/model/notificationModel.dart';
import 'package:frontend/resources/appURL.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class NotificationModelView extends GetxController {
  final RxList<Notifications> _notification = RxList();
  RxList<Notifications> get notification => _notification;

  RxMap<int, bool> isView = <int, bool>{}.obs;
  bool getIsView(int id) => isView[id] ?? false;
  Future<void> loadNotification() async {
    try {
      final res =
          await NetworkAPI().getRequest("${AppURL.getNotification}?userId=1");
      bool status = res['status'];
      String message = res['message'];
      if (status) {
        for (var data in res['data']) {
          _notification.add(Notifications.fromJson(data));
          // _notification.add(Notifications.fromJson(data));
        }
      } else {
        Utils.toastMessage(message);
      }
    } catch (e) {
      Utils.printMessage("Exception occured:$e");
    }
  }

  Future<void> viewNotification(int notificationId) async {
    try {
      String userId = "1";
      Map<String, dynamic> data = {
        "userId": userId,
        "notificationId": notificationId.toString()
      };
      final res = await NetworkAPI().postRequest(AppURL.seenNotification, data);
      bool status = res['status'];
      String message = res['message'];
      // _notification[index].isView = true;
      if (status) {
        final index =
            _notification.indexWhere((element) => element.id == notificationId);

        isView[notificationId] = true;
      }
      Utils.printMessage(message);

      update();
    } catch (e) {
      Utils.printMessage(e.toString());
    }
  }
}
