import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/model-view/ordre.dart';
import 'package:frontend/model/orderModel.dart';
import 'package:frontend/model/productModel.dart';
import 'package:frontend/model/reviewModels.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/boldText.dart';
import 'package:frontend/resources/components/incremenDecrementButton.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/resources/components/smallText.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/cartModel.dart';
import '../utils/constraints.dart';
import '../utils/topLevelFunction.dart';
import 'purchsePage.dart';

class SingleProduct extends StatefulWidget {
  const SingleProduct({super.key, required this.product});
  final Products product;
  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  final Utils _u = Get.find<Utils>();
  final OrderModel _o = Get.find<OrderModel>();
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: Utils.getHeight(context) * 0.4,
                            decoration: const BoxDecoration(),
                            child: Image(
                              // loadingBuilder: (context, child, loadingProgress) {
                              //   return CircularProgressIndicator();
                              // },
                              image: NetworkImage(widget.product.image),
                              //                    errorBuilder: (context, error, stackTrace) {
                              //   return  Image(image: AssetImage("asset/images/image5.jpeg"));

                              // },
                            )),
                      ],
                    ),
                    MediumText(
                      text: product.title,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BuildRow("Brand:", product.brand ?? "No brand"),
                        Column(
                          children: [
                            RatingBarIndicator(
                                itemCount: 5,
                                rating: product.average_rating ?? 0,
                                itemSize: 17,
                                unratedColor: AppColors.third,
                                itemBuilder: (context, index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  );
                                }),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 17,
                                  color: Colors.orange,
                                ),
                                SmallText(text: product.ratingCount.toString())
                              ],
                            )
                          ],
                        )
                      ],
                    ),

                    BuildCustomRadio(product.size ?? [], 1, "Size"),
                    BuildRow("Price :", product.price.toString()),
                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IncrementDecreent(
                          itemId: product.id,
                          oldCount: 1,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: MediumText(text: product.description ?? ""),
                    ),
                    BuildHilight(product.hilights ?? []),
                    if (product.reviews!.isNotEmpty) ...[
                      const BoldText(text: "Reviews"),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Wrap(children: BuildReviwsRow(product.reviews)),
                      )
                    ]

                    // SimilarProducts(products: products)
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  int userId = 1;
                  int productId = widget.product.id;
                  String paymentMethod = PaymentMethod.CASH;
                  double rate = widget.product.price;
                  int quantiy = productCout[productId.toString()] ?? 1;
                  Order order = Order(
                      userId: userId,
                      productId: productId,
                      payment: paymentMethod,
                      rate: rate,
                      quantity: quantiy,
                      title: widget.product.title!);
                  _o.handleOrder([order]);
                  final Products p = widget.product;
                  MyCartModel model = MyCartModel(
                      cart: CartModel(
                          id: productId,
                          title: p.title!,
                          category: p.category,
                          image: p.image,
                          average_rating: p.average_rating!,
                          ratingCount: p.ratingCount!,
                          price: p.price,
                          shopId: p.shopId!),
                      quantity: productCout[product.id] ?? 1);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PurchasePage(
                                model: [model],
                              )));
                  // Navigator.pushNamed(context, RoutesName.PurchasePage);
                },
                child: const Text(
                  "Buy Now",
                ))
          ],
        ),
      ),
    );
  }

  Widget BuildCustomRadio(List value, int selectedValue, String title) {
    CartModelView c = Get.find<CartModelView>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText(
          text: title,
        ),
        Obx(
          () => Wrap(
              children: List.generate(value.length, (index) {
            bool selectedIndexValue = c.getSelectedVarient(index);
            return InkWell(
              onTap: () {
                c.changeselectedVarient(
                    index, !selectedIndexValue ? true : false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                    color:
                        selectedIndexValue ? Colors.blue : AppColors.secondary,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  value[index].toString(),
                  style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(
                      color: selectedIndexValue
                          ? AppColors.secondary
                          : AppColors.third),
                ),
              ),
            );
          })),
        ),
      ],
    );
  }

  Widget BuildRow(String key, String value) {
    return Row(
      children: [
        BoldText(
          text: key,
        ),
        MediumText(
          text: value.toString(),
        )
      ],
    );
  }

  Widget BuildHilight(List hilights) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hilights.isNotEmpty
            ? const BoldText(
                text: "Hilights",
              )
            : Container(),
        Wrap(
          children: List.generate(hilights.length, (index) {
            return ListTile(
              leading: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.third),
              ),
              title: MediumText(
                text: hilights[index],
              ),
            );
          }),
        )
      ],
    );
  }

  List<Widget> BuildReviwsRow(List<Reviews>? reviews) {
    return List.generate(
        reviews!.length,
        (index) => Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(
                      text: reviews[index].feedback,
                    ),
                    SmallText(
                        text: DateFormat('yyyy-mm-dd hh:mm')
                            .format(reviews[index].created_at!)),
                    RatingBarIndicator(
                        // rating: reviews[index].rating,
                        itemCount: 5,
                        itemSize: 17,
                        unratedColor: AppColors.third,
                        itemBuilder: ((context, index) {
                          return const Icon(
                            Icons.star,
                            color: Colors.orange,
                          );
                        }))
                  ],
                )
              ],
            ));
  }
}
