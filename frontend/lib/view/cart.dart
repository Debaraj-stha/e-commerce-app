import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/buildIcon.dart';
import 'package:frontend/resources/components/buildTextButton.dart';
import 'package:frontend/resources/components/incremenDecrementButton.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:frontend/utils/utils.dart';

import 'package:get/get.dart';

import '../model-view/ordre.dart';
import '../resources/components/boldText.dart';
import '../utils/topLevelFunction.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartModelView _cartModelView = Get.find<CartModelView>();
  final Utils _utils = Get.find<Utils>();
  OrderModel _o=Get.find<OrderModel>();
  @override
  void initState() {
    // _cartModelView.getCartItem();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      computeIsolate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      // ignore: avoid_unnecessary_containers
      () => Stack(
  
        children: [
          Expanded(
            child: Column(
              children: [
                if (_cartModelView.isLoading.isTrue)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Utils.getHeight(context) * 0.4,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color:AppColors.primary,
                      ),
                    ),
                  ),
                if (_cartModelView.groupShop.isEmpty &&
                    _cartModelView.isLoading.isFalse) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Utils.getHeight(context) * 0.4,
                    ),
                    child: const Center(
                      child: MediumText(
                        text: "You do not have  any item int cart.",
                      ),
                    ),
                  ),
                ],
                Obx(
                  ()=>Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      // height: Utils.getHeight(context)*0.75,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _cartModelView.groupShop.length,
                          itemBuilder: (context, index) {
                            if (_cartModelView.groupShop.isEmpty &&
                                _cartModelView.isLoading.isFalse) {
                              return const Center(
                                child: Text(
                                  "There is no item in cart",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            
                            final product = _cartModelView.groupShop[index];
                            return Container(
                              margin: const EdgeInsets.only(top: 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  product.product.isNotEmpty
                                      ? Row(
                                          children: [
                                            Obx(
                                              () => Checkbox(
                                                value: _cartModelView
                                                    .getAllCheckedProduct(
                                                        product.shopId),
                                                onChanged: (value) {
                                                  _cartModelView.checkAllItem(
                                                      product.shopId,
                                                      product.product,
                                                      value!);
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: BoldText(
                                                  text: "Shop: ${product.shopId}"),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  ...product.product
                                      .map((item) => BuildCartItemWidget(
                                          item,
                                          product.shopId,
                                          index,
                                          product.product,
                                          context,_cartModelView))
                                      .toList(),
                                  product.product.isNotEmpty
                                      ? const Divider(
                                          thickness: 4,
                                          color: Color.fromARGB(255, 211, 206, 206))
                                      : Container(),
                                ],
                              ),
                            );
                          })),
                ),
              
              ],
            ),
          ),
            _cartModelView.groupShop.isNotEmpty &&
                        _cartModelView.isLoading.isFalse
                    ? Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10))),
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                      _cartModelView.isItemSelected.isTrue?  _cartModelView.deleteSelectedItem(context):null;
                                        setState(() {
                                          
                                        });
                                      },
                                      child: BuildIcon(
                                        icon: Icons.delete,
                                        iconColor:
                                            _cartModelView.isItemSelected.isTrue
                                                ? Colors.red
                                                : AppColors.secondary,
                                      )),
                                  BuildTextButton(
                                      child: Text(
                                        style: TextStyle(
                                            color: _cartModelView
                                                    .isItemSelected.isTrue
                                                ? Theme.of(context)
                                                    .primaryTextTheme
                                                    .titleMedium!
                                                    .color
                                                : AppColors.textColorPrimary),
                                        "Purchase",
                                      ),
                                      onPressed: () {
                                         _cartModelView.isItemSelected.isTrue?
                                        _cartModelView.orderCheckedItem(context):null;
                                        // Navigator.pushNamed(context, RoutesName.PurchasePage);
                                      })
                                ],
                              ),
                            )))
                    : Container()
        ],
      ),
    );
  }
}

Widget BuildCartItemWidget(
    item, shopId, int index, product, BuildContext context,cartModelView) {
  
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 10,
    ),
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Obx(
          () => Checkbox(
            value: cartModelView.getCheckedProduct(item.id.toString()),
            onChanged: (value) {
              cartModelView.checkProduct(item.id.toString(), value!, shopId);
            },
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(),
          child: Image(image: NetworkImage(item.image)),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BigText(
                text: item.title,
              ),
              const BigText(
                text: "Brand name",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BigText(
                    text: "Rs: ${item.price.toString()}",
                  ),
                  RatingBarIndicator(
                      unratedColor:
                          Theme.of(context).primaryTextTheme.bodyMedium!.color,
                      rating: 3,
                      itemSize: 17,
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: Colors.orange,
                        );
                      })
                ],
              ),
              IncrementDecreent(itemId: item.id, oldCount: 1)
            ],
          ),
        )
      ],
    ),
  );
}
