class Notifications {
  String title;
  String subTitle;
  int id;
  bool isSeen;
  DateTime created_at;
  String? imageURL;
  Notifications(
      {required this.title,
      required this.subTitle,
      this.isSeen = false,
      required this.id,
      required this.created_at,
      this.imageURL});
  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
      title: json['title'],
      subTitle: json['subTitle'],
      isSeen: json['isSeen'],
      id: json['id'],
      created_at: DateTime.parse(json['created_at']),
      imageURL: json['imageURL']);

  Map<String, dynamic> tojson() => {
        "title": title,
        "subTitle": subTitle,
        "id": id,
        "created_at": created_at,
        "isSeen": isSeen,
        "imageURL": imageURL
      };
}
