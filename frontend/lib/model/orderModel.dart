class Order {
  int? userId;
  int? productId;
  String? payment;
  int? quantity;
  double? rate;
  String? title;
  Order(
      {this.userId,
      this.productId,
      this.payment,
      this.quantity,
      this.rate,
      this.title});
  factory Order.fromJson(Map<String, dynamic> json) => Order(
        userId: json['usertid'],
        productId: json['productid'],
        title: json['title'],
        payment: json['payment'],
        quantity: json['quantity'],
        rate: json['rate'],
      );
  Map<String, dynamic> toJson() => {
        "title": title,
        "payment": payment,
        "quantity": quantity,
        "rate": rate,
        "productId": productId,
        "userId": userId,
      };
}
