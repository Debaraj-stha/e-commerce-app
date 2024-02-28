import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/model/productModel.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../../model/cartModel.dart';
import '../appColors.dart';
import '../components/buildIcon.dart';

class FilledAddToCArtButton extends StatefulWidget {
  const FilledAddToCArtButton({super.key, required this.product});
  final Products product;
  @override
  State<FilledAddToCArtButton> createState() => _FilledAddToCArtButtonState();
}

class _FilledAddToCArtButtonState extends State<FilledAddToCArtButton> {
  final CartModelView _cartModelView = Get.find<CartModelView>();
  final Utils _u = Get.find<Utils>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(_u.isProgress.value);
      return IconButton.filled(
        disabledColor: AppColors.third,
        isSelected: false,
        highlightColor: AppColors.secondary,
        tooltip: "Add To Cart",
        onPressed: () async {
          _u.toggleAddToCArtButton(widget.product.id.toString());
          CartModel cardModel =
              _cartModelView.getProductDetails(widget.product);

          await Future.delayed(const Duration(seconds: 2));
          _cartModelView.addToCart(cardModel, context);
        },
        icon: _u.getAddToCartProgress(widget.product.id.toString())
            ? CircularProgressIndicator(
                color: AppColors.primary,
              )
            : const BuildIcon(
                icon: FontAwesomeIcons.cartPlus,
                size: 20,
              ),
      );
    });
  }
}
