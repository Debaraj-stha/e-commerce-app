class Address {
  String? address;
  Address({this.address});
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
