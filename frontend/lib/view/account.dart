import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/model-view/accountViewModel.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/resources/components/buildIcon.dart';
import 'package:frontend/resources/components/buildListTile..dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final CartModelView _cartModelView = Get.find<CartModelView>();
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  @override
  void initState() {
    // TODO: implement initState
    // _cartModelView.getWishListItem();
    _accountViewModel.getUserDetails(context);
    _accountViewModel.getPurchaseData();
    super.initState();
  }

  String groupValue = "";
  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Obx(() => UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).bottomAppBarTheme.color),
              onDetailsPressed: () {},
              currentAccountPicture: const CircleAvatar(
                  child: BuildIcon(
                icon: Icons.person,
              )),
              accountName: Text(
                _accountViewModel.user.isNotEmpty
                    ? _accountViewModel.user[0].name!
                    : "Jhon",
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
              accountEmail: Text(
                _accountViewModel.user.isNotEmpty
                    ? _accountViewModel.user[0].name!
                    : "Jhon@xyz.com",
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ))),
          BuildListTile(
            title: "Wishlist",
            leading: FontAwesomeIcons.heart,
            onTap: () {
              _accountViewModel.handleListTileTap(context, RoutesName.Wishlist);
            },
          ),
          Obx(() => ExpansionTile(
                leading: const Icon(Icons.mode),
                title: const MediumText(
                  text: "Theme",
                ),
                children: [
                  RadioListTile<String>(
                      title: const MediumText(text: "Dark"),
                      value: "dark",
                      selected: true,
                      groupValue: _accountViewModel.selectedTheme.value,
                      onChanged: (value) {
                        _accountViewModel.handleThemeChange(value!);
                      }),
                  RadioListTile<String>(
                      title: const MediumText(text: "Light"),
                      value: "light",
                      groupValue: _accountViewModel.selectedTheme.value,
                      onChanged: (value) {
                        _accountViewModel.handleThemeChange(value!);
                      }),
                  RadioListTile<String>(
                      title: const MediumText(text: "Default"),
                      value: "default",
                      groupValue: _accountViewModel.selectedTheme.value,
                      onChanged: (value) {
                        _accountViewModel.handleThemeChange(value!);
                      }),
                ],
              )),
          Obx(
            () => ExpansionTile(
              leading: const Icon(FontAwesomeIcons.language),
              title: const MediumText(
                text: "Language",
              ),
              children: [
                RadioListTile<String>(
                    title: const MediumText(text: "Nepali"),
                    value: "nepali",
                    groupValue: _accountViewModel.selectedLamguage.value,
                    selected: true,
                    onChanged: (value) {
                      _accountViewModel.handleLanguageChange(value!);
                    }),
                RadioListTile<String>(
                    title: const MediumText(text: "English"),
                    value: "english",
                    groupValue: _accountViewModel.selectedLamguage.value,
                    onChanged: (value) {
                      groupValue = value!;
                      _accountViewModel.handleLanguageChange(value);
                    }),
                RadioListTile<String>(
                    title: const MediumText(text: "Hindi"),
                    value: "hindi",
                    groupValue: _accountViewModel.selectedLamguage.value,
                    onChanged: (value) {
                      groupValue = value!;
                      _accountViewModel.handleLanguageChange(value);
                    }),
              ],
            ),
          ),
          BuildListTile(
              title: "My order",
              leading: Icons.shopping_bag_outlined,
              onTap: () {
                _accountViewModel.handleListTileTap(context, RoutesName.Order);
              }),
          BuildListTile(
              title: "My Purchase",
              leading: FontAwesomeIcons.shop,
              onTap: () {
                _accountViewModel.handleListTileTap(
                    context, RoutesName.Purchase);
              }),
          BuildListTile(
              title: "My Reviews",
              leading: Icons.reviews,
              onTap: () {
                _accountViewModel.handleListTileTap(context, RoutesName.Review);
              }),
          BuildListTile(
              title: "Messages",
              leading: Icons.message_outlined,
              onTap: () {
                _accountViewModel.handleListTileTap(
                    context, RoutesName.Message);
              }),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: Utils.getWidth(context) * 0.3, vertical: 20),
            child: TextButton.icon(
                onPressed: () {
                  logout(
                      context,
                      _accountViewModel.user.isNotEmpty
                          ? _accountViewModel.user[0].id!
                          : 1);
                },
                icon: const Icon(
                  Icons.login_outlined,
                ),
                label: const Text(
                  "Logout",
                )),
          )
        ],
      ),
    ));
  }
}
