class Shops{
  int id;
  String name;
  String?address;
  String?phone;
  Shops({required this.id, required this.name,  this.address,  this.phone});
  factory Shops.fromJson(Map<String,dynamic> json)=>Shops(id: json['id'], name: json['name'], address: json['address'], phone: json['phone']);
  Map<String,dynamic> toJson()=>{
    "id":id,
    "name":name,
    "address":address,
    "phone":phone
  };
}