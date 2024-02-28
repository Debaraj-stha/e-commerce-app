import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/buildIcon.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/resources/components/rowProductItem.dart';
import 'package:frontend/resources/widget/stepperWidget.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  final CartModelView _cartModelView = Get.find<CartModelView>();
  final _utils = Get.find<Utils>();
  @override
  void initState() {
    // TODO: implement initState
    // _cartModelView.getWishListItem();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMyOrder();
    });
  }

  int? activeId;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const BigText(text: "My Orders"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (_cartModelView.isLoading.isTrue) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Utils.getHeight(context) * 0.4,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
                if (_cartModelView.myOrders.isEmpty &&
                    _cartModelView.isLoading.isFalse) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Utils.getHeight(context) * 0.4,
                    ),
                    child: const Center(
                      child: MediumText(
                        text: "You do not have order any item yet.",
                      ),
                    ),
                  ),
                ],
                if (_cartModelView.myOrders.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _cartModelView.myOrders.length,
                    itemBuilder: (context, index) {
                      final product = _cartModelView.myOrders[index];
                      final String id = product.cart.id.toString();
                      activeId = _utils.getActiveId(
                          product.cart.status ?? ORDER_STATUS.PENDING);

                      _utils.handleOrderState(id, activeId!);
                      print(product.cart.status);
                      return Column(
                        children: [
                          AnotherStepper(stepperList: [
                            BuildStepperData(ORDER_STATUS.PENDING, 1,
                                _utils.getOrderState(id)),
                            if (product.cart.status == ORDER_STATUS.CANCEL)
                              BuildStepperData(ORDER_STATUS.CANCEL, 1,
                                  _utils.getOrderState(id)),
                            BuildStepperData(ORDER_STATUS.ONTHEWAY, 3,
                                _utils.getOrderState(id)),
                            BuildStepperData(ORDER_STATUS.DELIVERED, 4,
                                _utils.getOrderState(id)),
                          ], stepperDirection: Axis.horizontal),
                          RowProductItem(
                            quantity: product.quantity,
                            product: product.cart,
                            cancellable: true,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          floatingActionButton: _cartModelView.myOrders.isEmpty &&
                  _cartModelView.isLoading.isFalse
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _utils.handleTap(1);
                  },
                  tooltip: "Order Item",
                  child: const BuildIcon(icon: Icons.shopping_bag_rounded),
                )
              : Container(),
        ));
  }
}
