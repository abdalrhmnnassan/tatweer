import 'dart:convert';
import 'package:http/http.dart' as http;

Future getLocation(String url,tokenType, accessToken) async{


  Map<String, String> headers = {"Content-type": "application/json", 'Accept': 'application/json',
    "authorization" : "Bearer $tokenType"};
  http.Response response = await http.get(url, headers:headers);

  return jsonDecode(response.body) ;

}