import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/model/productModel.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/buildIcon.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/resources/components/smallText.dart';
import 'package:frontend/resources/widget/buildFilledIconWishlistButton.dart';
import 'package:frontend/resources/widget/buildNetworkImage.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../widget/buildFilledaddToCartButton.dart';

class ProductCard extends StatelessWidget {
  ProductCard(
      {super.key,
      required this.product,
      this.isCartIcon = true,
      this.isCategory = false,
      this.isWishlistIcon = true});
  final Products product;
  final bool? isCartIcon;
  final bool? isWishlistIcon;
  final bool isCategory;
  final CartModelView _cartModelView = Get.find<CartModelView>();
  final Utils _u = Get.find<Utils>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 160,
        // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(5, 2),
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor),
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BuildNetworkImage(product.image),
            const SizedBox(
              height: 2,
            ),
            isCategory
                ? MediumText(
                    text: product.category.length > 15
                        ? product.category.substring(0, 15)
                        : product.category,
                  )
                : MediumText(
                    text: product.title!.length > 15
                        ? product.title!.substring(0, 15)
                        : product.title,
                  ),
            const SizedBox(
              height: 4,
            ),
            MediumText(
              text: "Rs:${product.price.toString()}",
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBarIndicator(
                    itemSize: 16,
                    rating: product.average_rating!,
                    unratedColor: Theme.of(context).primaryColorLight,
                    // unratedColor: Colors.black,
                    itemBuilder: (context, index) {
                      return const Icon(
                        Icons.star,
                        color: Colors.orange,
                      );
                    }),
                Container(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.orange,
                      ),
                      SmallText(
                        text: product.ratingCount.toString(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SmallText(
              text: "product id is${product.id}",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isCartIcon!
                    ? FilledAddToCArtButton(product: product)
                    : Container(),
                isWishlistIcon!
                    ? BuildFilledIconButon(productId: product.id.toString())
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
