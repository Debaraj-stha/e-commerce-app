void main() {
  String p = "lat=12&long=15";
  final x = p.split('&');
  for (var element in x) {
    final ele = element.split('=');
    print("key =${ele[0]}");
    print("value =${ele[1]}");
  }
}
