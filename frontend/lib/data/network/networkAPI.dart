import 'dart:convert';
import 'dart:io';

import 'package:frontend/data/appException.dart';
import 'package:frontend/data/network/baseAPI.dart';
import 'package:frontend/utils/utils.dart';
import 'package:http/http.dart' as http;

class NetworkAPI implements BaseAPI {
  @override
  Future postRequest(String url, Map data) async {
    dynamic response;
    try {
      final res = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));
      response = await getDecodedResponse(res);
      return response;
    } on SocketException {
      throw FetchDataException("No internet connection");
    } catch (e) {
      throw FetchDataException("Exception: $e");
    }
  }

  @override
  Future getRequest(String url) async {
    dynamic response;
    try {
      Utils.printMessage("url:$url");
      final res = await http.get(Uri.parse(url));
      response = await getDecodedResponse(res);
      return response;
    } on SocketException {
      throw FetchDataException("No internet connection");
    } catch (e) {
      throw FetchDataException(
          "Following error occurred while communicationg with server:\n $e");
    }
  }

  Future<dynamic> getDecodedResponse(http.Response res) async {
    switch (res.statusCode) {
      case 200:
        final data = await jsonDecode(res.body);
        return data;
      case 404:
        throw UnAuthorizedRequest("Inavlid request");
      case 501:
        throw InternalServerError(
            "Something is wrong on the server.Please try again");
      default:
        throw FetchDataException(
            "Something went wrong while communicationg with server");
    }
  }
}
