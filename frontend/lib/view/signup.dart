import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/model-view/signup-view.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/clipper.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/buildTextButton.dart';
import 'package:frontend/resources/components/buildTextField.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SignUpViewModel _signUpViewModel = SignUpViewModel();
  final Utils _utils = Get.find<Utils>();
  @override
  void initState() {
    // TODO: implement initState
    _signUpViewModel.initFields();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _signUpViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = Utils.getWidth(context);
    double height = Utils.getHeight(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    child: BigText(
                      text: "Sign Up",
                      color: AppColors.textColorPrimary,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(),
              child: Form(
                key: _signUpViewModel.formKey,
                child: Column(
                  children: [
                    BuildTextField(
                        type: 3,
                        label: "Full Name",
                        hint: "Full Name...",
                        controller: _signUpViewModel.nameController,
                        focusnode: _signUpViewModel.nameNode,
                        isObsecure: false,
                        onSubmit: (value) {
                          print(value);
                        },
                        prefix: const Icon(Icons.lock_outline),
                        onTapOutSide: () {}),
                    BuildTextField(
                        type: 4,
                        label: "Phone",
                        hint: "Phone",
                        controller: _signUpViewModel.phoneController,
                        focusnode: _signUpViewModel.phoneNode,
                        isObsecure: false,
                        onSubmit: (value) {
                          print(value);
                        },
                        prefix: const Icon(Icons.lock_outline),
                        onTapOutSide: () {}),
                    BuildTextField(
                        type: 1,
                        label: "Email",
                        hint: "Email...",
                        controller: _signUpViewModel.emailController,
                        focusnode: _signUpViewModel.emailNode,
                        onSubmit: (value) {
                          print(value);
                        },
                        prefix: const Icon(Icons.email_outlined),
                        onTapOutSide: () {}),
                    BuildTextField(
                        type: 2,
                        label: "Password",
                        hint: "Password...",
                        controller: _signUpViewModel.passwordController,
                        focusnode: _signUpViewModel.passwordsNode,
                        isObsecure: true,
                        onSubmit: (value) {
                          print(value);
                        },
                        suffix: InkWell(
                          onTap: _utils.togglePassword(),
                          child: const Icon(Icons.visibility_off_outlined),
                        ),
                        prefix: const Icon(Icons.lock_outline),
                        onTapOutSide: () {}),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    BuildTextButton(
                        onPressed: () {
                          _signUpViewModel.handleSubmit(context);
                        },
                        color: AppColors.primary,
                        child: Text(
                          "Sign Up",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.textColorPrimary),
                        )),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 1,
                          color: AppColors.third,
                          width: width * 0.4,
                        ),
                        const BigText(
                          text: "OR",
                        ),
                        Container(
                          height: 1,
                          color: AppColors.third,
                          width: width * 0.4,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const MediumText(
                      text: "Already have an account?",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BuildTextButton(
                        color: AppColors.third,
                        child: Text(
                          "login",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.textColorPrimary),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.Login);
                        }),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.third)),
                      label: Text(
                        "Login With Google",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.textColorPrimary),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.google,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
