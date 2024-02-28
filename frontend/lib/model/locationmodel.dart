class Address {
  String address;
  Address({required this.address});
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'address': address,
    };
  }
}
