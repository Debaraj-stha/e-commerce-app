import 'package:flutter/material.dart';
import 'package:frontend/model-view/signup-view.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/mediumText.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final SignUpViewModel _signUpViewModel = SignUpViewModel();
  @override
  void initState() {
    // TODO: implement initState
    _signUpViewModel.initFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText(
          text: "OTP Verification",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MediumText(
              text:
                  "We have sent an verification code to your email address.\nCheck your email and verify your account",
            ),
            TextField(
              controller: _signUpViewModel.otpConroller,
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () async {
                      await _signUpViewModel.sendVerificationRequest();
                    },
                    child: const Text("Resend OTP")),
                TextButton(
                    onPressed: () async {
                      await _signUpViewModel.veryfyAccount(context);
                    },
                    child: const Text("verify account")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
