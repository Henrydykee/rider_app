import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssitant {
  static Future<dynamic> getRequest(String url) async {
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = json.decode(jsonData);
        return decodeData;
      }else{
        return "failed";
      }
    } catch (err) {
      print("$err");
    }
  }
}
