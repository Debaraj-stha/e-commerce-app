import 'package:frontend/model/cartModel.dart';
import 'package:frontend/model/productModel.dart';
import 'package:frontend/model/userModel.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:frontend/utils/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/locationmodel.dart';

class DBController {
  static Database? database;
  String tableName = TableName.product;
  String userTableName = TableName.user;
  String orderTable = TableName.order;
  String purchaseTable = TableName.purchase;
  String wishlistTableName = TableName.wishlist;
  Future<Database?> get db async {
    // try {
    if (database != null) {
      return database;
    }
    database = await initDatabase();
    return database;
    // } catch (e) {
    //   throw e.toString();
    // }
  }

  Future<Database> initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "devrajdatabase.db");
    try {
      Database mydb = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          String sql =
              "create table $tableName (id INTEGER, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, average_rating REAL, ratingCount INTEGER, shopId TEXT,size TEXT,status Text,productId INTEGER)";

          String userTable =
              "create table $userTableName (id INTEGER PRIMARY KEY, name TEXT, image TEXT, address TEXT, email TEXT, phone TEXT)";
          String wishlist =
              "create table wishlist (id INTEGER,  title TEXT, price REAL, description TEXT, category TEXT, image TEXT, average_rating REAL, ratingCount INTEGER, shopId TEXT,size TEXT,status TEXT,productId INTEGER)";
          String orderSql =
              "create table $orderTable (id INTEGER,  title TEXT, price REAL, description TEXT, category TEXT, image TEXT, average_rating REAL, ratingCount INTEGER, shopId TEXT,size TEXT,status TEXT,productId INTEGER)";
          String purchase =
              "create table purchase (id INTEGER,  title TEXT, price REAL, description TEXT, category TEXT, image TEXT, average_rating REAL, ratingCount INTEGER, shopId TEXT,size TEXT,status TEXT,productId INTEGER)";
          String address = "create table address (address TEXT)";
          db.execute(orderSql);
          db.execute(purchase);
          db.execute(wishlist);
          db.execute(sql);
          db.execute(address);
          db.execute(userTable);
        },
        onUpgrade: (db, oldVersion, newVersion) {},
      );
      return mydb;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> insertAddress(Address a) async {
    try {
      final dbClient = await db;
      final res = await dbClient!.insert('address', a.toJson());
      if (res > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Utils.printMessage("Exception as :$e");
      return false;
    }
  }

  Future<bool> deleteWishlist(int id) async {
    final res = await delete(id, 'address');
    return res;
  }

  Future<Address> getAddress() async {
    final dbClient = await db;
    await dbClient!.delete('address');
    final res = await dbClient.query('address');
    return Address.fromJson(res[0]);
  }

  Future<bool> insertWishlist(CartModel p) async {
    final res = await insert(
      p,
      wishlistTableName,
    );
    return res;
  }

  Future<bool> updateWishlist(int id, Products p) async {
    final res = await update(id, wishlistTableName, p);
    return res;
  }

  Future<List<CartModel>> getWishlist() async {
    try {
      final dbClient = await db;
      if (dbClient == null) {
        return [];
      } else {
        final res = await dbClient.query(wishlistTableName);
        return res.map((e) => CartModel.fromJson(e)).toList();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<CartModel>> getCart() async {
    try {
      final dbClient = await db;
      if (dbClient == null) {
        return [];
      } else {
        final res = await dbClient.query(wishlistTableName);
        return res.map((e) => CartModel.fromJson(e)).toList();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> insertProduct(
    CartModel p,
  ) async {
    final res = await insert(
      p,
      tableName,
    );

    return res;
  }

  Future<bool> deleteData(int id) async {
    final res = await delete(id, tableName);
    return res;
  }

  Future<bool> updateData(int id, Products p) async {
    final res = await update(id, tableName, p);
    return res;
  }

  Future<bool> insertUser(Users u) async {
    try {
      final dbClient = await db;
      final value = await dbClient!.insert(userTableName, u.toJson());
      print(value);
      return true;
    } catch (e) {
      print('Error inserting user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final res = await delete(id, userTableName);
      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> updateUesr(int id, Users p) async {
    try {
      final res = await update(id, userTableName, p);
      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Users>> getUser() async {
    try {
      final dbClient = await db;
      if (dbClient == null) {
        print("null");
        return [];
      } else {
        final res = await dbClient.query(userTableName);
        print("res $res");
        return res.map((e) => Users.fromJson(e)).toList();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> insert(
    dynamic data,
    String tableName,
  ) async {
    final dbClient = await db;
    print(data.id);
    final res =
        await dbClient!.query(tableName, where: "id=?", whereArgs: [data.id]);

    if (res.isEmpty) {
      await dbClient.insert(tableName, data.toJson()).then((value) {
        return true;
      }).onError((error, stackTrace) {
        Utils.printMessage("exception occurred while inserting data: $error");
        throw error.toString();
      });
    } else {
      String table = tableName == wishlistTableName ? "Wishlist" : "Cart";
      throw "Product is already in $table";
    }
    return true;
  }

  Future<bool> delete(int id, String tableName) async {
    try {
      final dbClient = await db;
      await dbClient!
          .delete(tableName, where: "id=?", whereArgs: [id]).then((value) {
        return true;
      }).onError((error, stackTrace) {
        throw error.toString();
      });
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> update(int id, String tableName, dynamic data) async {
    try {
      final dbClient = await db;
      await dbClient!.update(tableName, data.toJson(),
          where: "id=?", whereArgs: [id]).then((value) {
        return true;
      }).onError((error, stackTrace) {
        throw error.toString();
      });
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deletePurchase(int id) async {
    final res = await delete(id, purchaseTable);
    return res;
  }

  Future<bool> updatePurchase(int id, Products p) async {
    final res = await update(id, purchaseTable, p);
    return res;
  }

  Future<List<CartModel>> getPurchase() async {
    try {
      final dbClient = await db;
      if (dbClient == null) {
        return [];
      } else {
        final res = await dbClient.query(purchaseTable);
        return res.map((e) => CartModel.fromJson(e)).toList();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> insertPurchase(MyCartModel p) async {
    try {
      Map<String, dynamic> data = buildMap(p);
      print(data);
      final myDb = await db;
      print(p.toJson());
      int inserted = await myDb!.insert(purchaseTable, data);
      if (inserted > 0) {
        print("Inserted successfully");
        return true;
      } else {
        print("Failed to insert");
        return false;
      }
    } catch (error) {
      print("Error inserting order: $error");
      throw error.toString();
    }
  }

  Future<bool> insertOrder(MyCartModel p) async {
    try {
      final Map<String, dynamic> data = buildMap(p);

      final myDb = await db;
      print(p.toJson());
      int inserted = await myDb!.insert(orderTable, data);
      if (inserted > 0) {
        print("Inserted successfully");
        return true;
      } else {
        print("Failed to insert");
        return false;
      }
    } catch (error) {
      print("Error inserting order: $error");
      throw error.toString();
    }
  }

  Future<bool> deleteOrder(int id) async {
    final res = await delete(id, orderTable);
    return res;
  }

  Future<List<MyCartModel>> getMyOrders() async {
    final dbClient = await db;
    if (dbClient == null) {
      return [];
    }
    final res = await dbClient.query(orderTable);
    return res.map((e) {
      final cart = buildCartModel(e);
      return MyCartModel(quantity: e['quantity'] as int, cart: cart);
    }).toList();
  }

  Future<List<MyCartModel>> getMyPurchase() async {
    final dbClient = await db;
    if (dbClient == null) {
      return [];
    }
    print("called");
    final res = await dbClient.query(purchaseTable);
    return res.map((e) {
      final cart = buildCartModel(e);
      Utils.printMessage(cart.toString());
      return MyCartModel(quantity: e['quantity'] as int, cart: cart);
    }).toList();
  }

  Future<bool> updateOrderStatus(int id, MyCartModel data) async {
    try {
      final res = await updateMapData(id, orderTable, data);
      if (res) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> updateMapData(int id, String tableName, MyCartModel data) async {
    print("outside try bloack");

    try {
      Map<String, dynamic> myMap = buildMap(data);
      print("inside try bloack");
      final dbClient = await db;
      print(myMap);
      final res = await dbClient!
          .update(tableName, myMap, where: "id=?", whereArgs: [id]);
      if (res > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Map<String, dynamic> buildMap(MyCartModel p) {
    CartModel c = p.cart;
    Map<String, dynamic> data = {
      "quantity": p.quantity,
      "price": c.price,
      "category": c.category,
      "image": c.image,
      "shopId": c.shopId,
      "title": c.title,
      "average_rating": c.average_rating,
      "ratingCount": c.ratingCount,
      "size": c.size,
      "id": c.id,
      "status": c.status,
      "productId": c.productId
    };
    return data;
  }

  CartModel buildCartModel(Map<String, Object?> e) {
    final cart = CartModel(
        id: e['id'] as int,
        title: e['title'] as String,
        category: e['category'] as String,
        image: e['image'] as String,
        average_rating: e['average_rating'] as double,
        ratingCount: e['ratingCount'] as int,
        shopId: e['shopId'] as String,
        price: e['price'] as double,
        productId: e['productId'] != null ? e['productId'] as int : 0,
        size: e['size'] as String ?? "M",
        status: e['status'] != null ? e['status'] as String : "pending");
    return cart;
  }
}
