import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/model-view/googleModelView.dart';
import 'package:frontend/model-view/messageView.dart';
import 'package:frontend/model-view/notificationModelView.dart';
import 'package:frontend/model-view/ordre.dart';
import 'package:frontend/model-view/reviewModelView.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:frontend/utils/handleTheme.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/view/googlemap.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model-view/accountViewModel.dart';
import 'model-view/cart-view.dart';
import 'model-view/home-view.dart';
import 'model-view/searchModelView.dart';
import 'repository/theme.dart';
import 'utils/topLevelFunction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sp = await SharedPreferences.getInstance();
  final String language = sp.getString(Constrains.localeKey) ?? "";
  final theme = await HandleTheme().getThememode();
  CartModelView cartModelView = Get.put(CartModelView());
  HomeModelView homeModelView = Get.put(HomeModelView());

  AccountViewModel accountViewModel = Get.put(AccountViewModel());
  NotificationModelView notificationViewModel =
      Get.put(NotificationModelView());
  SearchModeView searchModelView = Get.put(SearchModeView());
  Utils utils = Get.put(Utils());
  OrderModel o = Get.put(OrderModel());
  ReviewModelView r = Get.put(ReviewModelView());
  await dbController.initDatabase();

  bool login = await isLoggedIn();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  FirebaseMessaging.instance.subscribeToTopic('notification');
  MessageViewMOdel m = Get.put(MessageViewMOdel());
  GoogleModelView g = Get.put(GoogleModelView());
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true, sound: true, alert: true);

  runApp(MyApp(locale: language, themeMode: theme, loggedIn: login));
}

//resource://drawable/res_app_icon
class MyApp extends StatefulWidget {
  const MyApp(
      {super.key,
      required this.locale,
      required this.themeMode,
      required this.loggedIn});
  final String locale;

  final ThemeMode themeMode;
  final bool loggedIn;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
        publicKey: KhaltiConstraints.publicKey,
        builder: (context, navKey) {
          return GetMaterialApp(
            enableLog: true,
            navigatorKey: navKey,
            fallbackLocale: const Locale('en'),
            scrollBehavior: const MaterialScrollBehavior(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            locale: widget.locale == ""
                ? const Locale('en')
                : Locale(widget.locale),
            supportedLocales: const [Locale('en'), Locale('hi')],
            title: 'Flutter Demo',
            home: const GoogleMapPage(),
            // initialRoute: RoutesName.Home,
            // onGenerateRoute: Routes.generateRoute,
            themeMode: widget.themeMode,
            theme: Themes().lightTheme,
            darkTheme: Themes().darkTheme,
            checkerboardOffscreenLayers: true,
          );
        });
  }
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Background message$message");
}
