import 'package:flutter/material.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/view/googlemap.dart';
import 'package:frontend/view/home.dart';
import 'package:frontend/view/login.dart';
import 'package:frontend/view/loginSignupPage.dart';
import 'package:frontend/view/lowbudgetview.dart';
import 'package:frontend/view/myMessage.dart';
import 'package:frontend/view/myOrder.dart';
import 'package:frontend/view/paymentPage.dart';
import 'package:frontend/view/productCategory.dart';
import 'package:frontend/view/purchase.dart';
import 'package:frontend/view/purchsePage.dart';
import 'package:frontend/view/recommendedpage.dart';
import 'package:frontend/view/reviews.dart';
import 'package:frontend/view/signup.dart';
import 'package:frontend/view/wishlist.dart';

import 'routeName.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.Home:
        return MaterialPageRoute(builder: (context) => const Home());
      case RoutesName.Login:
        return MaterialPageRoute(builder: (context) => const Login());
      case RoutesName.Singup:
        return MaterialPageRoute(builder: (context) => const SignUp());
      case RoutesName.LoginSignup:
        return MaterialPageRoute(builder: (context) => const LoginSignup());
      case RoutesName.Wishlist:
        return MaterialPageRoute(builder: (context) => const Wishlist());
      case RoutesName.Purchase:
        return MaterialPageRoute(builder: (context) => const Purchase());
      case RoutesName.Order:
        return MaterialPageRoute(builder: (context) => const MyOrder());
      case RoutesName.Review:
        return MaterialPageRoute(builder: (context) => const MyReviews());
      case RoutesName.Message:
        return MaterialPageRoute(builder: (context) => const MyMessage());
      case RoutesName.LOWBUDGETPAGE:
        return MaterialPageRoute(
            builder: (context) => const LowBudgetProduct());
      case RoutesName.RECOMMENDEDPAGE:
        return MaterialPageRoute(builder: (context) => const RecommendedPage());
      case RoutesName.PurchasePage:
        return MaterialPageRoute(builder: (context) => const PurchasePage());
      case RoutesName.Payment:
        return MaterialPageRoute(builder: (context) => const PaymentPage());
      case RoutesName.CATEGORYPRODUCT:
        return MaterialPageRoute(builder: (context) => const CategoryProduct());
      case RoutesName.GOOGLEMAPPAGE:
        return MaterialPageRoute(builder: (context) => const GoogleMapPage());

      default:
        return MaterialPageRoute(builder: (context) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Back",
              backgroundColor: AppColors.third,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
            body: Center(
              child: Text(
                "Invalid route",
                style: Theme.of(context).primaryTextTheme.bodyLarge,
              ),
            ),
          );
        });
    }
  }
}
