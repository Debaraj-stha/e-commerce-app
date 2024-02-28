class Users {
  String? name;
  String? email;
  String? phone;
  String? address;
  int? id;
  String? image;
  Users({this.name, this.email, this.phone, this.address, this.id, this.image});
  factory Users.fromJson(Map<String, dynamic> json) => Users(
      name: json['name'],
      email: json['email'],
      id: json['id'],
      image: json['image'],
      phone: json['phone'],
      address: json['address']);
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "address": address,
      };
}
