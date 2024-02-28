import 'package:flutter/material.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/buildTextButton.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:frontend/utils/utils.dart';

import '../resources/appColors.dart';
import '../resources/clipper.dart';

class LoginSignup extends StatelessWidget {
  const LoginSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: MyPathClipper(),
                  child: Container(
                    alignment: Alignment.center,
                    height: Utils.getHeight(context) * 0.4,
                    width: 500,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(color: AppColors.third),
                  ),
                ),
                ClipPath(
                  clipper: MyPathClipper(),
                  child: Container(
                    alignment: Alignment.center,
                    height: Utils.getHeight(context) * 0.36,
                    width: 500,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: Utils.getHeight(context) * 0.1,
            // ),
            // Container(
            //   alignment: Alignment.center,
            //   child: Text(
            //     "Get Started",
            //     style: Theme.of(context)
            //         .primaryTextTheme
            //         .headlineLarge!
            //         .copyWith(color: AppColors.primary, fontFamily: "Roboto"),
            //   ),
            // ),
            const Spacer(),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              height: Utils.getHeight(context) * 0.3,
              child: Container(
                height: Utils.getHeight(context) * 0.3,
                decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(40))),
                child: ListView(
                  padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
                  children: [
                    BuildTextButton(
                        color: AppColors.primary,
                        child: MediumText(
                          text: "Login",
                          color: AppColors.textColorPrimary,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.Login);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    BuildTextButton(
                        color: AppColors.primary,
                        child: MediumText(
                          text: "Sign Up",
                          color: AppColors.textColorPrimary,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.Login);
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
