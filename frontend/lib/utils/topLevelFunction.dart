import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/model-view/cart-view.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:frontend/utils/routes/routeName.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/networkAPI.dart';
import '../model-view/home-view.dart';
import '../model/isolateData.dart';
import '../resources/appURL.dart';
import 'localeDb.dart';
import 'utils.dart';

Map<String, dynamic> productCout = {};
StreamController streamController = StreamController();
StreamController isDisabled = StreamController();
StreamController incrementController = StreamController();
late Stream stream;
late Stream isDisabledStream;
late Stream incrementControllerstream;
Map<String, bool> incrementMap = {};
Map<String, bool> decrementMap = {};
StreamController notificationStreamController = StreamController();
late Stream notificationStream;
CartModelView _cartModelView = Get.find<CartModelView>();
HomeModelView _homeModelView = Get.find<HomeModelView>();
Map<String, int> notificationMap = {};
DBController dbController = DBController();
void updateBadgeCount(String key) {
  if (notificationMap.containsKey(key)) {
    notificationMap[key] = notificationMap[key]! + 1;
  } else {
    notificationMap[key] = 1;
  }
  notificationStreamController.add(notificationMap);
  print("called");
  print(notificationMap);
}

initStream() {
  stream = streamController.stream.asBroadcastStream();
  notificationStream = notificationStreamController.stream.asBroadcastStream();
  isDisabledStream = isDisabled.stream.asBroadcastStream();
  incrementControllerstream = incrementController.stream.asBroadcastStream();
}

void incrementDecrement(
    String itemId, int oldCount, int type, BuildContext context) {
  if (!productCout.containsKey(itemId)) {
    productCout[itemId] = oldCount;
    print(productCout.containsKey(itemId));
    incrementMap[itemId] = false;
    decrementMap[itemId] = false;
  } else {
    print("inside else ");
    switch (type) {
      case 0:
        if (oldCount >= 5) {
          Utils().showSnackBar("You can't order more than 5", context);
          if (productCout[itemId] == 5) {
            incrementMap[itemId] = true;
            decrementMap[itemId] = false;
          }
        } else {
          productCout[itemId] = productCout[itemId]! + 1;
          incrementMap[itemId] = false;
          decrementMap[itemId] = false;
        }
        break;

      case 1:
        if (oldCount <= 1) {
          Utils().showSnackBar("You can't order less than 1", context);
          if (productCout[itemId] == 1) {
            incrementMap[itemId] = false;
            decrementMap[itemId] = true;
          }
        } else {
          productCout[itemId] = productCout[itemId]! - 1;
          incrementMap[itemId] = false;
          decrementMap[itemId] = false;
        }
        break;
    }
  }
  Utils.printMessage(productCout.toString());
  print("itemis $itemId ${productCout[itemId]}");
  streamController.add(productCout);
  isDisabled.add(decrementMap);
  incrementController.add(incrementMap);
  print("in $incrementMap");
  print("se $decrementMap");
}

computeIsolate() async {
  final receivePort = ReceivePort();
  var rootToken = RootIsolateToken.instance!;
  await Isolate.spawn<IsolateData>(
    getCartItem,
    IsolateData(
      token: rootToken,
      answerPort: receivePort.sendPort,
    ),
  );
  receivePort.listen((message) {
    print(message);
    _cartModelView.groupedCartItem(message);
  });
}

void getCartItem(IsolateData isolateData) async {
  List<CartModel> myCart = await getData(isolateData.token);

  BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);
  isolateData.answerPort.send(myCart);
  print("my cartData $myCart");
}

Future<List<CartModel>> getData(RootIsolateToken token) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(token);

  try {
    final dbClient = await dbController.db;
    if (dbClient == null) {
      return [];
    } else {
      final res = await dbClient.query(TableName.product);
      return res.map((e) => CartModel.fromJson(e)).toList();
    }
  } catch (e) {
    throw e.toString();
  }
}

getWishlistItem() async {
  final receivePort = ReceivePort();
  var rootToken = RootIsolateToken.instance!;
  await Isolate.spawn<IsolateData>(
    wishlistCart,
    IsolateData(
      token: rootToken,
      answerPort: receivePort.sendPort,
    ),
  );
  receivePort.listen((message) {
    print(message);
    _cartModelView.getWishListItem(message);
  });
}

// Future<List<Products>> getWishlist() async {
//   try {
//     final dbClient = await dbController.db;
//     if (dbClient == null) {
//       return [];
//     } else {
//       final res = await dbClient.query(TableName.wishlist);
//       return res.map((e) => Products.fromJson(e)).toList();
//     }
//   } catch (e) {
//     throw e.toString();
//   }
// }

void wishlistCart(IsolateData isolateData) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);
  List<CartModel> myWishlist = await dbController.getWishlist();
  isolateData.answerPort.send(myWishlist);
}

getPurchaseData() async {
  ReceivePort receivePort = ReceivePort();
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  await Isolate.spawn<IsolateData>(
    _getMyPurchaseData,
    IsolateData(
      token: rootIsolateToken,
      answerPort: receivePort.sendPort,
    ),
  );
  receivePort.listen((message) {
    _cartModelView.getPurchaseData(message);
  });
}

void _getMyPurchaseData(IsolateData isolateData) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);

  List<MyCartModel> purchase = await dbController.getMyPurchase();
  isolateData.answerPort.send(purchase);
}

getWishList() async {
  ReceivePort receivePort = ReceivePort();
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  await Isolate.spawn<IsolateData>(
    _getWishlist,
    IsolateData(
      token: rootIsolateToken,
      answerPort: receivePort.sendPort,
    ),
  );
  receivePort.listen((message) {
    _cartModelView.getWishListItem(message);
  });
}

void _getWishlist(IsolateData isolateData) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);

  List<CartModel> myWishlist = await dbController.getWishlist();
  isolateData.answerPort.send(myWishlist);
}

Future<bool> isLoggedIn() async {
  final sp = await SharedPreferences.getInstance();
  bool res = sp.getBool(Constrains.LOGINKEY) ?? false;
  return res;
}

Future<void> logout(BuildContext context, int id) async {
  final sp = await SharedPreferences.getInstance();
  bool res = await sp.setBool(Constrains.LOGINKEY, false);
  dbController.deleteUser(id);
  Navigator.pushNamed(context, RoutesName.Login);
}

back(BuildContext context) {
  Navigator.of(context).pop();
}

insertOrder(MyCartModel order) async {
  ReceivePort receivePort = ReceivePort();
  RootIsolateToken token = RootIsolateToken.instance!;
  IsolateData data =
      IsolateData(answerPort: receivePort.sendPort, token: token);
  Map<String, dynamic> myMap = {"order": order, "isolate": data};
  await Isolate.spawn(_insertMyOrder, myMap);
  receivePort.listen((message) {
    print(message);
  });
}

void _insertMyOrder(Map<String, dynamic> data) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(data['isolate'].token);
  try {
    await dbController.insertOrder(data['order']).then((value) {
      if (value) {
        Utils.printMessage("success");
        data['isolate'].answerPort.send(true);
      } else {
        print("fails");
        data['isolate'].answerPort.send(false);
      }
    });
  } catch (e) {
    print(e);
  }
}

updateOrder(int id, BuildContext context, MyCartModel model) async {
  ReceivePort receivePort = ReceivePort();
  RootIsolateToken token = RootIsolateToken.instance!;
  Map<String, dynamic> data = {
    "id": id,
    "isolate": IsolateData(answerPort: receivePort.sendPort, token: token),
    "model": model,
  };
  await Isolate.spawn(_updateOrder, data);
  receivePort.listen((message) {
    print(message);
    if (message) {
      _cartModelView.cancelOrder(id, context, model);

      Utils().showSnackBar("Order status updated successfully", context);
    } else {
      Utils().showSnackBar("Order is not placed", context);
    }
  });
}

void _updateOrder(Map<String, dynamic> data) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(data['isolate'].token);
  final res = await dbController.updateOrderStatus(data['id'], data['model']);
  final receivePort = data['isolate'].answerPort;
  if (res) {
    receivePort.send(true);
  } else {
    receivePort.send(false);
  }
  // data['receivePort'].send(res);
}

getMyOrder() async {
  ReceivePort receivePort = ReceivePort();
  RootIsolateToken token = RootIsolateToken.instance!;
  IsolateData data =
      IsolateData(token: token, answerPort: receivePort.sendPort);
  await Isolate.spawn<IsolateData>(_getOrders, data);
  receivePort.listen((message) {
    _cartModelView.getMyOrders(message);
  });
}

_getOrders(IsolateData data) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(data.token);
  try {
    List<MyCartModel> res = await dbController.getMyOrders();
    print(res.toString());
    data.answerPort.send(res);
  } catch (e) {
    Utils.printMessage(e.toString());
  }
}

getRecommendet(BuildContext context,
    {isLoadMore = false, limit = 10, offset = 0}) async {
  print("method called");
  ReceivePort receivePort = ReceivePort();
  RootIsolateToken token = RootIsolateToken.instance!;
  IsolateData data = IsolateData(
      token: token, answerPort: receivePort.sendPort, isLoadMore: isLoadMore);

  Map<String, dynamic> map = {
    "isolate": data,
    "limit": limit,
    "offset": offset,
  };
  try {
    print("insie try");
    await Isolate.spawn(_getRecommendet, map);
    receivePort.listen((message) {
      print("message: $message");
      _homeModelView.loadRecommendedData(context, message,
          isLoadMore: isLoadMore);
    });
  } catch (e) {
    print("inside cartch");
    Utils.printMessage(e.toString());
  }
}

_getRecommendet(Map<String, dynamic> data) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(data['isolate'].token);
  int limit = data['limit'];
  int offset = data['offset'];
  try {
    String url = "${AppURL.recommendation}?limit=$limit&offset=$offset";
    final res = await NetworkAPI().getRequest(url);
    data['isolate'].answerPort.send(res);
  } catch (e) {
    throw e.toString();
  }
}

getLowBudget(BuildContext context,
    {isLoadMore = false, limit = 10, offset = 0}) async {
  ReceivePort receivePort = ReceivePort();
  RootIsolateToken token = RootIsolateToken.instance!;
  IsolateData data = IsolateData(
      token: token, answerPort: receivePort.sendPort, isLoadMore: isLoadMore);

  Map<String, dynamic> map = {
    "isolate": data,
    "limit": limit,
    "offset": offset,
  };
  try {
    await Isolate.spawn(_getLowBudget, map);
    receivePort.listen((message) {
      _homeModelView.loadLowBudgetData(context, message,
          isLoadMore: isLoadMore);
    });
  } catch (e) {
    Utils.printMessage(e.toString());
  }
}

_getLowBudget(Map<String, dynamic> data) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(data['isolate'].token);
  int limit = data['limit'];
  int offset = data['offset'];
  try {
    String url = "${AppURL.lowBudget}?limit=$limit&offset=$offset";
    final res = await NetworkAPI().getRequest(url);
    print("res$res");
    data['isolate'].answerPort.send(res);
  } catch (e) {
    throw e.toString();
  }
}

getCategory(BuildContext context,
    {isLoadMore = false, limit = 10, offset = 0}) async {
  ReceivePort receivePort = ReceivePort();
  RootIsolateToken token = RootIsolateToken.instance!;
  IsolateData data = IsolateData(
      token: token, answerPort: receivePort.sendPort, isLoadMore: isLoadMore);

  Map<String, dynamic> map = {
    "isolate": data,
    "limit": limit,
    "offset": offset,
  };
  try {
    await Isolate.spawn(_getCategory, map);
    receivePort.listen((message) {
      _homeModelView.loadCategory(context, message, isLoadMore: isLoadMore);
      print(message.toString());
    });
  } catch (e) {
    Utils.printMessage(e.toString());
  }
}

_getCategory(Map<String, dynamic> data) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(data['isolate'].token);
  int limit = data['limit'];
  int offset = data['offset'];
  try {
    String url = "${AppURL.categoryGroup}?limit=$limit&offset=$offset";
    final res = await NetworkAPI().getRequest(url);
    data['isolate'].answerPort.send(res);
  } catch (e) {
    throw e.toString();
  }
}
