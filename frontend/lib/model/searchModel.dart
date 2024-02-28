
class SearchProduct {
    final int id;

    final String title;

    final String image;
    final double price;
    

    SearchProduct({
        required this.id,
        
        required this.title,
        required this.image,
        required this.price,
       
    });



  factory SearchProduct.fromJson(Map<String, dynamic> json) => SearchProduct(
      id: json['id'],
       title: json['title'],
  image: json['image'],
     
      price: double.parse(json['price']));
}
