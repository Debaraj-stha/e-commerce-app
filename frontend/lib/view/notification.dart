import 'package:flutter/material.dart';
import 'package:frontend/model-view/notificationModelView.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/resources/components/smallText.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../utils/Notifier.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Utils _utils = Get.find<Utils>();
  final NotificationModelView _noti = Get.find<NotificationModelView>();
  bool isHide = false;
  FirebaseMessage message = FirebaseMessage();
  @override
  void initState() {
    // TODO: implement initState
    _noti.loadNotification();
    message.RequestPermission();
    message.initFirebase(context);
    message.getToken();
    message.interactMessage(context);

    // connect(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Obx(() => SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: _noti.notification.isEmpty
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          vertical: Utils.getHeight(context) * 0.4),
                      child: const Column(
                        children: [
                          Center(
                            child: MediumText(
                              text: "No notification available",
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          List.generate(_noti.notification.length, (index) {
                        final notification = _noti.notification[index];
                        return InkWell(
                          onTap: () {
                            _noti.viewNotification(notification.id);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                              color: _noti.getIsView(notification.id)
                                  ? AppColors.textColorPrimary
                                  : AppColors.secondary,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: const CircleAvatar(
                                    radius: 30,
                                    // onBackgroundImageError: (exception, stackTrace) {
                                    //   _utils.showSnackBar("Unable to load image", context);
                                    // },
                                    child: Icon(Icons.image),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BigText(text: notification.title),
                                      MediumText(
                                        text: notification.subTitle.length > 60
                                            ? notification.subTitle
                                                .substring(0, 60)
                                            : notification.subTitle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SmallText(
                                          text: notification.created_at
                                              .toIso8601String())
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      })),
            )));
  }
}
