import 'productModel.dart';
import 'userModel.dart';

class Reviews {
  int? id;
  Products? product;
  double rating;
  String? feedback;
  DateTime? created_at;
  Users? user;
  Reviews(
      {required this.id,
      this.product,
      this.user,
      this.rating = 1.0,
      required this.created_at,
      this.feedback
      // }
      });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
      id: json['id'],
      user: json['user'] != null ? Users.fromJson(json['user']) : null,
      product:
          json['product'] != null ? Products.fromJson(json['product']) : null,
      created_at: DateTime.parse(json['created_at']),
      rating: json['rating'] != null
          ? double.parse(json['rating'].toString())
          : 0.0,
      feedback: json['feedback']);
  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product != null ? product!.toJson() : null,
        "rating": rating,
        "created_at": created_at,
        "feedback": feedback,
        'user': user != null ? user!.toJson() : null
      };
}
