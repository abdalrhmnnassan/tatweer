import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// this function to login with the correct UserName and Password by API
Future login(String username , String password , String _locale, var dateGMT) async {
  const url = "https://storeak-identity-service-beta.azurewebsites.net/api/v1/token";
  var body = jsonEncode({ //jsonEncode encodes a given value to a string using JSON syntax
   "clientId"	  : "e58744b2-4103-4705-8694-d38c8f2f19fb",
    "clientSecret": "DZHCYHBZDKLVUMRGKLDJDDBGZQVNFBGY",
    "Username"	  : "$username", // To set the UserName after fetching it from the interface
    "Password": "$password",/////// To set the Password after fetching it from the interface
    "PlayerId" : "" ,
    "Language" : '${_locale.toString().substring(0,2)}',// to set language phone and sub into tow char ex:en, ar
    "GMT" : "$dateGMT" , ///////// To set the time at which a user is registered
    "IsFromNotification" : "false"  // to set notification true or false if user open app on notification or no

  });

  http.Response response = await http.post(url, headers: {"Content-type": "application/json"} , body: body);

  return jsonDecode(response.body) ;

}

// this function to login without UserName and Password by API
Future loginanonymous(String _locale, var dateGMT) async {
  const url = "https://storeak-identity-service-beta.azurewebsites.net/api/v1/token";
  var body = jsonEncode({
    "clientId"	  : "e58744b2-4103-4705-8694-d38c8f2f19fb",
    "clientSecret": "DZHCYHBZDKLVUMRGKLDJDDBGZQVNFBGY",
    "PlayerId" : "" ,
    "Language" : '${_locale.toString().substring(0,2)}',
    "GMT" : "$dateGMT" ,
    "IsFromNotification" : "false"
  });
  http.Response response = await http.post(url, headers: {"Content-type": "application/json"} , body: body);

  return jsonDecode(response.body) ;

}