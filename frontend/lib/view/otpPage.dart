import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/model-view/signup-view.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/mediumText.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final SignUpViewModel _signUpViewModel = SignUpViewModel();
  late Timer _timer;
  int _remainingMinutes = 60 * 5;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingMinutes == 0) {
          _timer.cancel();
          print("Timer expired");
        } else {
          _remainingMinutes--;
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MediumText(
              text:
                  "We have sent an verification code to your email address.\nCheck your email and verify your account",
            ),
            const MediumText(
              text: "The OTP will expires in",
            ),
            const SizedBox(
              height: 19,
            ),
            BigText(
              text: "${_remainingMinutes.toString().padLeft(2, '0')} seconds",
            ),
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: TextField(
                onTapOutside: (event) {
                  _signUpViewModel.optNode.unfocus();
                },
                focusNode: _signUpViewModel.optNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.third)),
                    hintText: "Enter otp here...",
                    hintStyle: Theme.of(context).primaryTextTheme.bodySmall),
                controller: _signUpViewModel.otpConroller,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            _remainingMinutes != 0
                                ? Colors.grey
                                : AppColors.primary)),
                    onPressed: () async {
                      await _signUpViewModel.veryfyAccount(context);
                    },
                    child: const Text("verify account")),
                TextButton(
                    onPressed: () async {
                      if (_remainingMinutes == 0) {
                        await _signUpViewModel.sendVerificationRequest();
                      }
                    },
                    child: const Text("Resend OTP")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
