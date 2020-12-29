import 'package:http/http.dart' as http;
import 'dart:convert';

Future getLocation(String url,tokenType, accessToken) async {
  Map<String, String> headers = {"Content-type": "application/json",
    "authorization" : "$tokenType $accessToken"};
  http.Response response = await http.get(url, headers:headers);
  return jsonDecode(response.body) ;
}