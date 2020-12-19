import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//////////////////////////
////////////////////////
//to do
////////////////////////
///////////////////////
class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
  // This Accesss_Token and Token_type contain the data coming from API and store the access token and token type from http.post
  String Accesss_Token ;
  String Token_type ;
  Location({this.Accesss_Token, this.Token_type});
}

class _LocationState extends State<Location> {
  String _mySelection;

  final String url = "https://storeak-gps-service-beta.azurewebsites.net/api/v1/Locations";

  List data = List(); //edited line

  Future<String> getSWData() async {

    var res = await http
        .get(Uri.encodeFull(url), headers: {"Content-type": "application/json", 'Accept': 'application/json',
      "authorization" : "Bearer  ${widget.Accesss_Token}"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    for(var i = 0; i < data.length; i++){
    // print(data[i]["children.name"]);
    }
  //  print(resBody);



  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: new Center(
        child: new DropdownButton(
          hint: Text("To Do"),
          items: data.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['name'].toString()),
              value: item['id'].toString(),
            );
          }).toList(),
          onChanged: (newVal) {
            setState(() {
              _mySelection = newVal;
              print(_mySelection.toString());

            });
          },
          value: _mySelection,
        ),
      ),
    );
  }
}
