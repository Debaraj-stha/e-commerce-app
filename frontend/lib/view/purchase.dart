import 'package:flutter/material.dart';
import 'package:frontend/model-view/accountViewModel.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/buildIcon.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/resources/components/rowProductItem.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class Purchase extends StatefulWidget {
  const Purchase({super.key});

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  final CartModelView _cartModelView = Get.find<CartModelView>();
  final Utils _utils = Get.find<Utils>();
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
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
      getPurchaseData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const BigText(text: "Purchase"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (_accountViewModel.isLOading.isTrue) ...[
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
                if (_accountViewModel.myPurchaqse.isEmpty &&
                    _accountViewModel.isLOading.isFalse) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Utils.getHeight(context) * 0.4,
                    ),
                    child: const Center(
                      child: MediumText(
                        text: "You do not have purchased any item yet.",
                      ),
                    ),
                  ),
                ],
                if (_accountViewModel.myPurchaqse.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _cartModelView.purchaseData.length,
                    itemBuilder: (context, index) {
                      final product = _accountViewModel.myPurchaqse[index];
                      print("product id");
                      print(product.cart.id);
                      return RowProductItem(
                        product: product.cart,
                        quantity: product.quantity,
                        isReview: true,
                        onTap: _cartModelView.handleProductTap,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          floatingActionButton: _cartModelView.purchaseData.isEmpty &&
                  _cartModelView.isLoading.isFalse
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _utils.handleTap(1);
                  },
                  tooltip: "Buy Now",
                  child: const BuildIcon(icon: Icons.shopping_bag_rounded),
                )
              : Container(),
        ));
  }
}
