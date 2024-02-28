class Message {
  int id;
  String message;
  DateTime createdAt;
  DateTime? updatedAt;
  int receiverId;

  Shop shop;
  bool isSeen;
  bool isSender;

  Message(
      {required this.id,
      required this.isSender,
      required this.isSeen,
      required this.message,
      required this.createdAt,
      this.updatedAt,
      required this.receiverId,
      required this.shop});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        isSender: json['isSender'],
        message: json['message'],
        createdAt: DateTime.parse(json['created_at']),
        isSeen: json['isSeen'],
        receiverId: json['receiverId'],
        shop: Shop.fromJson(json['shop']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}

class Shop {
  int id;
  String? name;
  String? address;
  String? phone;

  Shop({required this.id, this.name, this.address, this.phone});

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone']);
}
