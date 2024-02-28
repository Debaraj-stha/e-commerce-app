import 'package:flutter/material.dart';
import 'package:frontend/model-view/accountViewModel.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/model-view/home-view.dart';
import 'package:frontend/model-view/searchModelView.dart';
import 'package:frontend/resources/widget/buildBadge.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/view/account.dart';
import 'package:frontend/view/cart.dart';
import 'package:frontend/view/ecplore.dart';
import 'package:frontend/view/homeContent.dart';
import 'package:frontend/view/notification.dart';
import 'package:get/get.dart';

import '../utils/topLevelFunction.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _tabsContent = [
    const HomeContent(),
    const Cart(),
    const Explore(),
    const NotificationPage(),
    const Account()
  ];

  CartModelView cartModelView = Get.find<CartModelView>();
  HomeModelView homeModelView = Get.find<HomeModelView>();

  AccountViewModel accountViewModel = Get.find<AccountViewModel>();
  Utils utils = Get.find<Utils>();
  final SearchModeView _s = Get.put(SearchModeView());
  @override
  void initState() {
    // TODO: implement initState
    initStream();
    initStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // backgroundColor:
        //     Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            child: Obx(() => _tabsContent[utils.currentIndex.value]),
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            backgroundColor: Colors.red,
            onTap: utils.handleTap,
            currentIndex: utils.currentIndex.value,
            selectedIconTheme:
                Theme.of(context).bottomNavigationBarTheme.selectedIconTheme,
            selectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedIconTheme:
                Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
            unselectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                  tooltip: "Home"),
              BottomNavigationBarItem(
                  icon: StreamBuilder(
                      stream: notificationStream,
                      builder: ((context, snapshot) {
                        print(snapshot.data);
                        return BuildBadge(Icons.shopping_cart_outlined,
                            snapshot.data != null ? snapshot.data['cart'] : 0);
                      })),
                  label: "Cart",
                  tooltip: "Cart"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  label: 'Explore',
                  tooltip: "Explore"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: "Botification",
                  tooltip: "Botification"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Account',
                  tooltip: "Account"),
            ],
          ),
        ));
  }
}
