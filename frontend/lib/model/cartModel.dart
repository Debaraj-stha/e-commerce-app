class CartModel {
  int id;
  String title;
  String category;

  String image;
  double average_rating;
  int ratingCount;
  String shopId;
  double price;
  String? size;
  String? status;
  int? productId;
  CartModel({
    required this.id,
    this.productId,
    required this.title,
    this.status = "pending",
    required this.category,
    required this.image,
    required this.average_rating,
    required this.ratingCount,
    required this.price,
    required this.shopId,
    this.size,
  });
  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        average_rating: json["average_rating"],
        ratingCount: json["ratingCount"],
        shopId: json["shopId"],
        price: json["price"],
        status: json['status'],
        size: json["size"],
        productId: json['productId'],
        title: json["title"],
        id: json['id'],
        category: json["category"],
        image: json["image"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "category": category,
        "image": image,
        "shopId": shopId,
        "title": title,
        "productId": productId,
        "average_rating": average_rating,
        "ratingCount": ratingCount,
        "price": price,
        "size": size
      };
}

class MyCartModel {
  int quantity;
  CartModel cart;
  MyCartModel({required this.quantity, required this.cart});
  factory MyCartModel.fromJson(Map<String, dynamic> json) => MyCartModel(
      quantity: json['quantity'], cart: CartModel.fromJson(json['cart']));
  Map<String, dynamic> toJson() =>
      {"quantity": quantity, "cart": cart.toJson()};
}
