import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/model-view/notificationModelView.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/view/notification.dart';
import 'package:http/http.dart' as http;

class FirebaseMessage {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();
  void RequestPermission() async {
    NotificationSettings permission = await messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.authorized) {
      Utils.printMessage("Notification permission granted");
    } else {
      Utils.printMessage("Notification permission denied");
    }
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    Utils.printMessage("token $token");
    return token!;
  }

  void initFirebase(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((event) {
      if (kDebugMode) {
        Utils.printMessage(event.data.toString());
        Utils.printMessage(event.notification.toString());
        print(event.toMap());
      }
      if (Platform.isAndroid) {
        initNotification(context, event);
        showNotification(event);
      } else {
        showNotification(event);
      }
    });
  }

  initNotification(BuildContext context, RemoteMessage mesage) {
    print("init called");
    AndroidInitializationSettings settings =
        const AndroidInitializationSettings('@mipmap/bell');
    DarwinInitializationSettings setting = const DarwinInitializationSettings();
    InitializationSettings initializationSettings =
        InitializationSettings(android: settings, iOS: setting);
    notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        handleMessage(context, mesage);
      },
    );
  }

  Future<void> interactMessage(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      handleMessage(context, message);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  handleMessage(BuildContext context, RemoteMessage message) async {
    if (message.data['type'] == 'notification') {
      await NotificationModelView().viewNotification(message.data['id']);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NotificationPage()));
    }
  }

  showNotification(RemoteMessage message) async {
    print("show notification");
    bool checkImage = isNetworkImage(message.notification!.android!.imageUrl!);
    print(checkImage);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            setAsGroupSummary: true,
            colorized: true,
            channelShowBadge: true,
            importance: Importance.max,
            fullScreenIntent: true,
            color: Colors.red,
            priority: Priority.max,
            groupKey: "notification",
            channelDescription: 'big text channel description',
            styleInformation: await loadFiles(message
                    .notification!.android!.imageUrl ??
                "D:/flutter/e-commerse-clean/frontend/asset/images/image5.jpeg"),
            // await loadSystemFile("asset/images/image5.jpeg"),
            ticker: "ticker");
    DarwinNotificationDetails iconDetails =
        const DarwinNotificationDetails(presentAlert: true, presentBadge: true);
    NotificationDetails details = NotificationDetails(
        android: androidNotificationDetails, iOS: iconDetails);
    try {
      notificationPlugin.show(
          1, message.notification!.title, message.notification!.body, details,
          payload: jsonEncode(message.data));
    } catch (e) {
      print(e);
      Utils.printMessage("Exception:$e");
    }
  }

  bool isNetworkImage(String url) {
    final x = url.contains('http') || url.contains('https');
    return x;
  }

  Future<BigPictureStyleInformation> loadFiles(String path) async {
    if (isNetworkImage(path)) {
      final http.Response response = await http.get(Uri.parse(path));
      BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(response.bodyBytes)));
      return bigPictureStyleInformation;
    }
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(path));
    return bigPictureStyleInformation;
  }
}
