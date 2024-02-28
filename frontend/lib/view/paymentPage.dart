// import 'package:esewa_pnp/esewa.dart';

import 'package:flutter/material.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  khaltiPay(BuildContext context) {
    PaymentConfig config = PaymentConfig(
        amount: 20 * 100, productIdentity: "3322", productName: "product name");
    void onSuccess(PaymentSuccessModel model) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Payment successful"),
                actions: [
                  SimpleDialogOption(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
    }

    void onFailure(PaymentFailureModel failure) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Payment Failure"),
                actions: [
                  SimpleDialogOption(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
    }

    KhaltiScope.of(context).pay(
      config: config,
      onSuccess: onSuccess,
      onFailure: onFailure,
      preferences: [
        PaymentPreference.khalti,
        PaymentPreference.connectIPS,
        PaymentPreference.mobileBanking
      ],
      onCancel: onCancel(context),
    );
  }

  onCancel(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Payment Failure"),
              actions: [
                SimpleDialogOption(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  // final ESewaConfiguration _configuration = ESewaConfiguration(
  //     clientID: EsewaConstraints.clientID,
  //     secretKey: EsewaConstraints.secretKey,
  //     environment: ESewaConfiguration.ENVIRONMENT_TEST);
  // late ESewaPnp _esesewaPnp;
  // String callBackUrl = "https://example.com";
  // double amount = 100;
  // String productId = "123";
  // String productName = "testname";
  // onSuccess(result) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(result.message.toString())));
  // }

  // void onFailure(error) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(error.message.toString())));
  // }

  esewaPnp() {}
  @override
  void initState() {
    // TODO: implement initState
    // _esesewaPnp = ESewaPnp(configuration: _configuration);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildButton("Pay with Khalti", () {
              khaltiPay(context);
            }),
            BuildButton("Cash on delivery", () {}),
             BuildButton("Pay with Esewa", () {}),
            // BuildButton("Pay with Esewa", () {
            //   ESewaPayment(
            //     amount: 333,
            //     productID: "33",
            //     callBackURL: callBackUrl,
            //     productName: productName,
            //   );
            // }),
          ],
        ),
      ),
    );
  }

  Widget BuildButton(String title, VoidCallback callback) {
    return Center(
      child: InkWell(
        onTap: () {
          callback();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
          child: Text(
            title,
            style: Theme.of(context)
                .primaryTextTheme
                .bodyMedium!
                .copyWith(color: AppColors.textColorPrimary),
          ),
        ),
      ),
    );
  }
}
