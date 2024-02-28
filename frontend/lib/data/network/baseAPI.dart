abstract class BaseAPI {
  Future<dynamic> getRequest(String url,);
  Future<dynamic> postRequest(String url,Map data);
}
