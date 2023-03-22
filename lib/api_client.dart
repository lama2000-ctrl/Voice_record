import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:voice_record/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart' as resp;

class ApiClient extends GetConnect implements GetxService {
  late String token;

  //ate SharedPreferences sharedPreferences;
  late Map<String, String> mainHeaders;

  ApiClient() {
    timeout = const Duration(seconds: 30);

    mainHeaders = {
      "authorization": "02ff6b9b8e5048169cb67c8c369cfc19",
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      print(mainHeaders);
      resp.Response response = await get(uri, headers: mainHeaders);
      return response;
    } catch (e) {
      print("nooooooooooooooo");
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      print("post.........");
      resp.Response response = await post(uri, body, headers: mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
