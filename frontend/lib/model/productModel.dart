import 'package:frontend/model/cartModel.dart';
import 'package:frontend/model/reviewModels.dart';

import 'shopModel.dart';

class Products {
  int id;
  String? title;
  double price;
  String? description;
  String category;
  String image;
  double? average_rating;
  int? ratingCount;
  Shops? shop;
  String? brand;
  List<dynamic>? size;
  List<dynamic>? hilights;
  List<dynamic>? tags;
  List<Reviews>? reviews;
  String? shopId;
  Products({
    required this.category,
    required this.image,
    this.shop,
    this.tags,
    this.reviews,
    this.brand,
    this.ratingCount,
    this.shopId,
    required this.id,
    required this.title,
    this.hilights,
    required this.price,
    required this.description,
    this.average_rating,
    this.size,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json['id'],
        shopId: "1",
        size: json['size'],
        ratingCount: json['ratingCount'],
        category: json['category'],
        shop: json['shop'] != null
            ? Shops.fromJson(
                json['shop'],
              )
            : null,
        reviews: json['reviews'] != null
            ? List<Reviews>.from(json['reviews']
                .map((reviewJson) => Reviews.fromJson(reviewJson)))
            : <Reviews>[],
        tags: json['tags'],

        hilights: json['hilights'],
        brand: json['brand'],
        price: json['price'] != null
            ? double.parse(json['price'].toString())
            : 0.0, // Parse price as string
        description: json['description'],
        title: json['title'],
        image: json['image'],
        average_rating: json['average_rating'] != null
            ? double.parse(json['average_rating'].toString())
            : 0.0, // Parse average_rating as string
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "size": size,
        "shop": shop != null ? shop!.toJson() : null,
        "shopId": shopId,
        "ratingCount": ratingCount,
        "category": category,
        "title": title,
        "price": price,
        "hilights": hilights,
        "reviews": reviews!.map((e) => e.toJson()),
        "brand": brand,
        "description": description,
        "image": image,
        "average_rating": average_rating,
      };
}

class GroupedByShop {
  final List<CartModel> product;
  final String shopId;
  GroupedByShop({required this.shopId, required this.product});
  factory GroupedByShop.fromJson(Map<String, dynamic> json) => GroupedByShop(
      shopId: json['shopId'],
      product: List<CartModel>.from(
          json['product'].map((ele) => CartModel.fromJson(ele))));
  Map<String, dynamic> toJson() => {"shopId": shopId, "product": product};
}
