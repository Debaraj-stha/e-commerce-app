import 'package:flutter/material.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../appColors.dart';
import '../components/buildIcon.dart';

class BuildFilledIconButon extends StatefulWidget {
  const BuildFilledIconButon({super.key, required this.productId});
  final String productId;
  @override
  State<BuildFilledIconButon> createState() => _BuildFilledIconButonState();
}

class _BuildFilledIconButonState extends State<BuildFilledIconButon> {
  final Utils _u = Get.find<Utils>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(_u.isProgress.toString());
      return IconButton.filled(
          disabledColor: AppColors.third,
          isSelected: false,
          hoverColor: AppColors.primary,
          color: AppColors.primary,
          splashColor: AppColors.third,
          autofocus: true,
          tooltip: "Add to Wishlist",
          onPressed: () async {
            _u.toggleProgress(widget.productId);
            // CartModel cardModel =
            //     _cartModelView.getProductDetails(product);
            // _cartModelView.addToWishlist(cardModel, context);
            // await Future.delayed(const Duration(seconds: 2));
          },
          icon: _u.getItemProgress(widget.productId)
              ? Container(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                )
              : const BuildIcon(
                  icon: Icons.favorite_outline_outlined,
                  size: 25,
                ));
    });
  }
}
