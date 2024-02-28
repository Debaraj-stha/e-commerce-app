import 'package:flutter/material.dart';
import 'package:frontend/model-view/ordre.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/boldText.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../resources/widget/dialog.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key, this.model});
  final List<MyCartModel>? model;
  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final OrderModel _o = Get.find<OrderModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText(text: "Purchase"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BoldText(
                    text: "Item",
                  ),
                  BoldText(
                    text: "Rate",
                  ),
                  BoldText(
                    text: "Quantity",
                  ),
                  BoldText(
                    text: "Price",
                  )
                ],
              ),
              Obx(() => ListView.builder(
                    itemBuilder: (context, index) {
                      final item = _o.order[index];
                      print("item $item");
                      double price = item.quantity! * item.rate!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BuildProductRow(
                            item.title!, item.rate!, item.quantity!, price),
                      );
                    },
                    itemCount: _o.order.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  )),
              const Divider(),
              const SizedBox(height: 100),
              Column(
                children: [
                  BuildRow("Discount", "Rs:180"),
                  BuildRow("SubTotal", "Rs:180"),
                  BuildRow("Total", "Rs:180")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    if (widget.model == null) {}
                    showPayMentDialog(context, widget.model!);
                  },
                  icon: Icon(Icons.done,
                      color: Theme.of(context).iconTheme.color),
                  label: Text(
                    "Procced",
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.textColorPrimary),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildRow(String text, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediumText(
            text: text,
          ),
          MediumText(
            text: value,
          )
        ],
      ),
    );
  }

  Widget BuildProductRow(String item, double rate, int quantity, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Utils.getWidth(context) * 0.4,
          child: MediumText(
            text: item,
          ),
        ),
        Container(
          child: MediumText(
            text: "Rs:$rate",
          ),
        ),
        MediumText(
          text: "$quantity",
        ),
        MediumText(
          text: "Rs:$price",
        )
      ],
    );
  }
}
