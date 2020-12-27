import 'package:http/http.dart' as http;
import 'dart:convert';

Future getLocation(String url,token_type, access_token) async {
  Map<String, String> headers = {"Content-type": "application/json",
    "authorization" : "$token_type $access_token"};
  http.Response response = await http.get(url, headers:headers);
  return jsonDecode(response.body) ;
}