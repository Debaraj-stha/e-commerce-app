import 'package:flutter/material.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/buildIcon.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/resources/components/rowProductItem.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final CartModelView _cartModelView = Get.find<CartModelView>();
  final Utils _utils = Get.find<Utils>();
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
      getWishlistItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const BigText(text: "Wishlist"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (_cartModelView.isLoading.isTrue)
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Utils.getHeight(context) * 0.4),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )),
                  ),
                if (_cartModelView.wishlistItem.isEmpty &&
                    _cartModelView.isLoading.isFalse)
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Utils.getHeight(context) * 0.4),
                    child: const Center(
                      child: MediumText(text: "No item in wishlist"),
                    ),
                  ),
                if (_cartModelView.wishlistItem.isNotEmpty) ...[
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cartModelView.wishlistItem.length,
                      itemBuilder: (context, index) {
                        final product = _cartModelView.wishlistItem[index];
                        print("sishlist item: ${product.toJson()}");
                        return RowProductItem(
                            product: product,
                            isShowButton: true,
                            onTap: _cartModelView.handleProductTap);
                      })
                ]
              ],
            ),
          ),
          floatingActionButton: _cartModelView.wishlistItem.isEmpty &&
                  _cartModelView.isLoading.isFalse
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _utils.handleTap(0);
                  },
                  tooltip: "Add item to wishlist",
                  child: const BuildIcon(icon: Icons.add),
                )
              : Container(),
        ));
  }
}
