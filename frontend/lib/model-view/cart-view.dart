import 'package:flutter/material.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/model/orderModel.dart';
import 'package:frontend/model/productModel.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:frontend/utils/localeDb.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/view/purchsePage.dart';
import 'package:get/get.dart';

import '../data/network/networkAPI.dart';
import '../resources/appURL.dart';
import '../utils/topLevelFunction.dart';
import 'ordre.dart';

class CartModelView extends GetxController {
  final RxList<GroupedByShop> _groupByShopId = RxList();
  RxList<GroupedByShop> get groupShop => _groupByShopId;

  RxMap<String, bool> checkedProductMap = <String, bool>{}.obs;
  RxMap<String, bool> allChecked = <String, bool>{}.obs;
  RxMap<String, Map<String, bool>> productIdWithShopId =
      <String, Map<String, bool>>{}.obs;
  bool getCheckedProduct(String itemId) => checkedProductMap[itemId] ?? false;
  bool getAllCheckedProduct(String shopId) => allChecked[shopId] ?? false;
  final RxList<CartModel> _cartItem = RxList();
  final RxList<CartModel> _wishlistItem = RxList();

  RxList<CartModel> get cartItem => _cartItem;
  RxList<CartModel> get wishlistItem => _wishlistItem;
  final RxList<MyCartModel> _purchaseData = RxList();
  RxList<MyCartModel> get purchaseData => _purchaseData;
  final RxList<MyCartModel> _myOrders = RxList();
  RxList<MyCartModel> get myOrders => _myOrders;
  final Utils _utils = Utils();

  final DBController _dbController = DBController();
  RxBool isLoading = RxBool(true);
  RxBool isItemSelected = RxBool(false);
  groupedCartItem(List<CartModel> cartItem) async {
    if (_cartItem.isEmpty) {
      _cartItem.addAll(cartItem);
      final shopId = [];
      await Future.delayed(const Duration(seconds: 2));
      if (cartItem.isNotEmpty) {
        for (final _product in cartItem) {
          if (!shopId.contains(_product.shopId)) {
            shopId.add(_product.shopId);
            isLoading.value = false;
            _groupByShopId.add(
                GroupedByShop(shopId: _product.shopId, product: [_product]));
          } else {
            isLoading.value = false;
            final index = _groupByShopId
                .indexWhere((group) => group.shopId == _product.shopId);
            _groupByShopId[index].product.add(_product);
          }
          print("_groupByShopId:$_groupByShopId");
        }
      }
      isLoading.value = false;
      update();
    } else {
      Utils.printMessage("Already called this method");
    }
  }

  checkProduct(String itemId, bool value, String shopId) {
    checkedProductMap[itemId] = value;

    isItemSelected.value = checkedProductMap.containsValue(true);

    productIdWithShopId[shopId] ??= {};
    productIdWithShopId[shopId]![itemId] = value;

    Utils.printMessage("checked item ${checkedProductMap.toString()}");
    Utils.printMessage(
        "product with shop id item ${productIdWithShopId.toString()}");
    update();
  }

  checkAllItem(String shopId, List<CartModel> products, bool value) {
    allChecked[shopId] = value;

    for (var _product in products) {
      productIdWithShopId[shopId] ??= {};
      productIdWithShopId[shopId]![_product.id.toString()] = true;
      checkProduct(_product.id.toString(), value, shopId);
    }

    update();
    Utils.printMessage("all checked item ${allChecked.toString()}");
  }

  Map getCheckedItem() {
    final shopId = productIdWithShopId.keys.toList();
    List x = [];
    for (var val in shopId) {
      final y = productIdWithShopId[val]!.keys.toList();
      x.add(y);
    }
    Map<String, dynamic> res = {"shopId": shopId, "productId": x};
    return res;
  }

  void orderCheckedItem(BuildContext context) {
    OrderModel o = Get.find<OrderModel>();
    List<Order> order = [];
    List<MyCartModel> model = [];
    final keys = getCheckedItem();
    final shopIdList = keys['shopId'];
    final productIdList = keys['productId'];
    for (var i = 0; i < productIdList[0].length; i++) {
      var productId = productIdList[0][i];
      print("productId $productId");
      print("crt item ${cartItem.length}");

      final item =
          _cartItem.where((item) => item.id == int.parse(productId)).first;
      final rate = item.price;
      String title = item.title;
      print("rate$rate");
      final quantity = productCout[productId] ?? 1;
      Order order0 = Order(
          quantity: quantity,
          userId: 1,
          productId: int.parse(productId),
          rate: rate,
          title: title);
      order.add(order0);
      CartModel cart = CartModel(
          id: item.id,
          title: title,
          category: item.category,
          image: item.image,
          average_rating: item.average_rating,
          ratingCount: item.ratingCount,
          price: item.price,
          shopId: item.shopId);
      MyCartModel cartmodel = MyCartModel(quantity: quantity, cart: cart);
      model.add(cartmodel);
    }
    o.handleOrder(order);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PurchasePage(
                  model: model,
                )));
    // Navigator.pushNamed(context, RoutesName.PurchasePage);
  }

  void deleteSelectedItem(BuildContext context) async {
    final keys = getCheckedItem();
    final shopIdList = keys['shopId'];
    final productIdList = keys['productId'];

    for (var i = 0; i < shopIdList.length; i++) {
      final shopId = shopIdList[i];
      groupShop
          .firstWhere((group) => group.shopId == shopId)
          .product
          .removeWhere(
              (product) => productIdList[i].contains(product.id.toString()));

      groupShop.obs;
    }
    for (var i = 0; i < productIdList[0].length; i++) {
      var productId = productIdList[0][i];
      final id =
          _cartItem.where((item) => item.id == int.parse(productId)).first.id;
      await deleteCartItem(id, context);
    }

    isItemSelected.value = false;
    update();
  }

  Future<void> addToCart(CartModel p, BuildContext context) async {
    print(p.toJson());
    await _dbController.insertProduct(p).then((value) {
      if (value) {
        _cartItem.add(p);
        int index = _groupByShopId
                .indexWhere((element) => element.shopId == p.shopId) ??
            _groupByShopId.length;
        _groupByShopId[index].product.add(p);

        _utils.showSnackBar("Product added to cart successfully", context);
      }
    }).onError((error, stackTrace) {
      _utils.showSnackBar(error.toString(), context, isSuccess: false);
    });
    update();
  }

  Future<void> addToWishlist(CartModel p, BuildContext context) async {
    await _dbController.insertWishlist(p).then((value) {
      if (value) {
        _utils.showSnackBar("Product added to woishlist successfully", context);
      }
    }).onError((error, stackTrace) {
      _utils.showSnackBar(error.toString(), context, isSuccess: false);
    });
    update();
  }

  Future<void> deleteCartItem(int id, BuildContext context) async {
    await _dbController.deleteData(id).then((value) {
      if (value) {
        _utils.showSnackBar("Product added from cart successfully", context);
      }
    }).onError((error, stackTrace) {
      _utils.showSnackBar(error.toString(), context, isSuccess: false);
    });
    update();
  }

  Future<void> deleteWishlistItem(int id, BuildContext context) async {
    await _dbController.deleteWishlist(id).then((value) {
      if (value) {
        _utils.showSnackBar(
            "Product deleted from woishlist successfully", context);
      }
    }).onError((error, stackTrace) {
      _utils.showSnackBar(error.toString(), context, isSuccess: false);
    });
    update();
  }

  Future<void> updateCartItem(
      int id, Products product, BuildContext context) async {
    await _dbController.updateData(id, product).then((value) {
      if (value) {
        _utils.showSnackBar("Product updated successfully", context);
      }
    }).onError((error, stackTrace) {
      _utils.showSnackBar(error.toString(), context, isSuccess: false);
    });
    update();
  }

  // getCartItem(SendPort sendPort) async {
  //   List<Products> myCart = await getData();
  //   _cartItem.value = myCart;
  //   groupedCartItem();
  //   sendPort.send(_groupByShopId);
  //   print(cartItem);
  //   update();
  // }

  Future<void> getWishListItem(List<CartModel> p) async {
    Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    _wishlistItem.addAll(p);
    update();
  }

  Future<void> getPurchaseData(List<MyCartModel> p) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    _purchaseData.addAll(p);
    update();
  }

  handleProductTap(CartModel p) {
    Utils.printMessage("ontap");
  }

  void getMyOrders(List<MyCartModel> products) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    List<MyCartModel> res = await dbController.getMyPurchase();
    _purchaseData.addAll(res);
    _myOrders.addAll(products);
    update();
  }

  CartModel getProductDetails(Products product) {
    CartModel cartModel = CartModel(
        id: product.id,
        title: product.title!,
        category: product.category,
        image: product.image,
        average_rating: product.average_rating!,
        ratingCount: product.ratingCount!,
        price: product.price,
        shopId: product.shopId!,
        size: product.size![0] ?? "No size");
    return cartModel;
  }

  cancelOrder(int id, BuildContext context, MyCartModel model) async {
    try {
      Map<String, dynamic> data = {
        "orderId": id.toString(),
        "status": ORDER_STATUS.CANCEL
      };
      final res = await NetworkAPI().postRequest(AppURL.updateOrder, data);
      final message = res['message'];
      String status = res['status'];
      if (status.toLowerCase() == 'success') {
        print(id);
        MyCartModel model = _myOrders.firstWhere((ele) => ele.cart.id == id);
        model.cart.status = ORDER_STATUS.CANCEL;
        update();
      }
      Utils().showSnackBar(message, context);
    } catch (e) {
      Utils.printMessage(e.toString());
    }
  }

  Future<void> insertPurchase(MyCartModel model, BuildContext context) async {
    try {
      final res = await dbController.insertPurchase(model);
      if (res) {
        Utils().showSnackBar("purchased successfully", context);
      } else {
        Utils().showSnackBar("purchased is not successful", context);
      }
    } catch (e) {
      Utils.printMessage("exception$e");
    }
  }

  RxMap<int, dynamic> selectedVarient = <int, dynamic>{}.obs;
  bool getSelectedVarient(int key) => selectedVarient[key] ?? false;
  changeselectedVarient(int key, bool value) {
    selectedVarient.updateAll((key, value) => false);
    selectedVarient[key] = value;

    update();
  }
}
