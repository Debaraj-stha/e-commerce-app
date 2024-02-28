import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/model-view/ordre.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/model/orderModel.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/incremenDecrementButton.dart';
import 'package:frontend/resources/widget/buildNetworkImage.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:frontend/view/giveReview.dart';
import 'package:frontend/view/purchsePage.dart';
import 'package:get/get.dart';

import '../../utils/constraints.dart';
import 'bigText.dart';
import 'mediumText.dart';

class RowProductItem extends StatefulWidget {
  const RowProductItem(
      {super.key,
      this.isReview = false,
      required this.product,
      this.quantity,
      this.onTap,
      this.cancellable = false,
      this.isShowButton = false});
  final CartModel product;
  final Function? onTap;
  final int? quantity;
  final bool isReview;
  final bool isShowButton;
  final bool cancellable;
  @override
  State<RowProductItem> createState() => _RowProductItemState();
}

class _RowProductItemState extends State<RowProductItem> {
  final CartModelView _cartModelView = Get.find<CartModelView>();
  final OrderModel _orderModel = Get.find<OrderModel>();
  buildModel(BuildContext context, String itemId, CartModel product) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Quantity",
              style: Theme.of(context)
                  .primaryTextTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.textColorPrimary),
            ),
            content: IncrementDecreent(oldCount: 1, itemId: int.parse(itemId)),
            actions: [
              TextButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    back(context);
                  },
                  child: Text(
                    "Close",
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.textColorPrimary),
                  )),
              TextButton(
                  onPressed: () async {
                    Order order = Order(
                        quantity: productCout[itemId] ?? 1,
                        title: product.title,
                        userId: 1,
                        productId: product.id,
                        rate: product.price);
                    print(order.toJson());
                    _orderModel.order.add(order);
                    MyCartModel model = MyCartModel(
                        cart: product, quantity: productCout[product.id] ?? 1);

                    back(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchasePage(
                                  model: [model],
                                )));
                    // Navigator.pushNamed(context, RoutesName.PurchasePage);
                  },
                  child: Text(
                    "Ok",
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.textColorPrimary),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(widget.product);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, top: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            BuildNetworkImage(widget.product.image),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(
                    text: widget.product.title.length > 40
                        ? widget.product.title.substring(0, 40)
                        : widget.product.title,
                  ),
                  const MediumText(
                    text: "Brand name",
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MediumText(
                    text: "Rs :${widget.product.price}",
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  widget.quantity != null
                      ? MediumText(
                          text: "Quantity :$widget.quantity",
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  const MediumText(
                    text: "Total cost :Rs 3637.99",
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RatingBarIndicator(
                      itemCount: 5,
                      rating: widget.product.average_rating,
                      itemSize: 20,
                      unratedColor: Theme.of(context).primaryColorDark,
                      itemBuilder: (context, index) {
                        return const Icon(color: Colors.orange, Icons.star);
                      }),
                  const SizedBox(
                    height: 5,
                  ),
                  widget.isShowButton
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton.icon(
                                onPressed: () {
                                  _cartModelView.addToCart(
                                      widget.product, context);
                                },
                                icon: const Icon(FontAwesomeIcons.cartPlus),
                                label: Text(
                                  "Add  To Cart",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: AppColors.textColorPrimary),
                                )),
                            TextButton.icon(
                                onPressed: () {
                                  buildModel(
                                      context,
                                      widget.product.id.toString(),
                                      widget.product);
                                  // insertOrder(product);
                                },
                                icon: const Icon(FontAwesomeIcons.shop),
                                label: Text(
                                  "Buy Now",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: AppColors.textColorPrimary),
                                ))
                          ],
                        )
                      : Container(),
                  widget.cancellable &&
                          widget.product.status != ORDER_STATUS.CANCEL
                      ? TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            MyCartModel model =
                                MyCartModel(cart: widget.product, quantity: 4);
                            model.quantity = 15;
                            model.cart.status = "cancel";
                            updateOrder(widget.product.id, context, model);
                          },
                          child: const Text("Cancel Order"))
                      : Container(),
                  widget.isReview
                      ? InkWell(
                          child: Text(
                            "Add review",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyMedium!
                                .copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GiveReview(model: widget.product)));
                          },
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
