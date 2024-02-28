class TableName {
  static String product = "product";
  static String user = "user";
  static String wishlist = "wishlist";
  static String purchase = "purchase";
  static String order = "myorder";
}

class Constrains {
  static String themeKey = "themeKey";
  static String localeKey = "localeKey";
  static String LOGINKEY = "loginKey";
}

class KhaltiConstraints {
  static String secretKey = "test_secret_key_b1f782f2c6204a078c68c92ffc551387";
  static String publicKey = "test_public_key_b5947817558a4684a37dd15752e25dec";
}

class EsewaConstraints {
  static String clientID =
      "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R";

  static String secretKey = "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==";
}

class PaymentMethod {
  static const ESEWA = "esewa";
  static const KHALTI = "khalti";
  static const CASH = "cash";
}

class ORDER_STATUS {
  static const PENDING = 'pending';
  static const CANCEL = 'cancel';

  static const ONTHEWAY = 'on the way';

  static const DELIVERED = 'delivered';
}
