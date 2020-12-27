import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t/services/services_get_location.dart';

class Location_ extends StatefulWidget {
  @override
  _Location_State createState() => _Location_State();
  // This Accesss_Token and Token_type contain the data coming from API and store the access token and token type from http.post
  String Accesss_Token ;
  String Token_type ;
  Location_({this.Accesss_Token, this.Token_type});
}
class _Location_State extends State<Location_> {
  String Id_Select_Country;// to store Id after Select Country
  String Id_Select_City;// to store Id after Select City
  String Id_Select_District;// to store Id after Select District

  final String url = "https://storeak-gps-service-beta.azurewebsites.net/api/v1/Locations";
  List citys = new List(); // this list to store data city after select Country
  List District = new List();// this list to store data District after select city
  List data = List(); // this list to store all data from api
  @override
  void initState() { // this ini to Initialize data from api
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body:FutureBuilder(
        future: getLocation(url ,widget.Token_type , widget.Accesss_Token ),
        builder: (context ,snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else{
            data = snapshot.data;
          }
          return SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox( // Horizontal ListView
                    height: 75,
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(

                          children: [
                            Expanded(
                              child: new DropdownButton(
                                hint: Text("Country"),
                                items: data.map((item) {// this map that contain data from api to show Country
                                  return new DropdownMenuItem(
                                    child: new Text(item['name'].toString()), // this name that come back from list method of json
                                    value: item['id'].toString(),// this ID that come back from list method of json
                                  );
                                }).toList(),
                                onChanged: (newVal) {  // to set  Id_Select_Country = newVal and to access into id
                                  setState(() {
                                    /*
                            * To report whether it is empty or not because it is empty, and if it is not empty,
                            * This means that the user has not made any selection for the country,
                            * This means that if the city is specified or the city and region are specified and the same country is chosen,
                            * No data retrieval required.
                            * */
                                    if (newVal.length==0){
                                      Id_Select_Country = newVal;
                                      for (int i=0;i<data.length;i++){
                                        if (data[i]['id'].toString()==Id_Select_Country.toString()){
                                          citys=data[i]['children'];
                                          break;
                                        }
                                      }

                                    }else{
                                      /*
                              * To test whether the value we previously chose is the same or not,
                              * if it is the same here, then it will do nothing,
                              * but if it is other then that means that the values for the city and
                              * District should be empty if it was specified earlier and the city data must be re-fetched
                              * */
                                      if (Id_Select_Country!=newVal){
                                        Id_Select_Country = newVal;
                                        Id_Select_City = null;
                                        Id_Select_District = null;
                                        // print(_mySelection.toString());
                                        for (int i=0;i<data.length;i++){
                                          if (data[i]['id'].toString()==Id_Select_Country.toString()){
                                            citys=data[i]['children'];
                                            break;
                                          }
                                        }
                                      }

                                    }


                                    //print(data1[1]['children'][0]['name']);
                                  });
                                },
                                value: Id_Select_Country,
                              ),
                            ),

                            citys.isEmpty?Expanded(
                              child: DropdownButton(
                                //To select a city and it displays a city if the country is not selected
                                  hint: Text("City")
                              ),
                            )
                                :new Expanded(child:DropdownButton(

                              hint: Text("City"),
                              items: citys.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['name'].toString()),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  /*
                              * To report whether it is empty or not because it is empty, and if it is not empty,
                              * This means that the user did not perform any city selection process,
                              * This means that if the city is specified or the region is determined and the same city is chosen,
                              * No data retrieval required.
                              * */
                                  if(newVal.length==0){
                                    Id_Select_City = newVal;
                                    for (int i=0;i<citys.length;i++){
                                      if (citys[i]['id'].toString()==Id_Select_City.toString()){
                                        District=citys[i]['children'];
                                        break;
                                      }
                                    }
                                  }else{
                                    /*
                              * To test whether the value we previously selected is the same or not,
                              * If she's the same here, she'd do nothing,
                              * But if not then this means that the region values should be blank if previously specified and data must be fetched
                              * */
                                    if (Id_Select_City!=newVal){
                                      Id_Select_City = newVal;
                                      Id_Select_District = null;
                                      for (int i=0;i<citys.length;i++){
                                        if (citys[i]['id'].toString()==Id_Select_City.toString()){
                                          District=citys[i]['children'];
                                          break;
                                        }
                                      }
                                    }
                                  }

                                });
                              },
                              value: Id_Select_City,
                            )),

                            District.isEmpty?Expanded (
                              child: DropdownButton(
                                //To Selects the District and displays a city if the city is not selected
                                  hint: Text("District")
                              ),
                            )
                                : Expanded(child:DropdownButton(
                              hint: Text("District"),
                              items: District.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['name'].toString() ,),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  Id_Select_District = newVal;
                                /*  print(Id_Select_Country.toString());
                                  print(Id_Select_City.toString());
                                  print(Id_Select_District.toString());*/
                                });
                              },
                              value: Id_Select_District,
                            )),
                          ],
                        ),
                      ],
                    )

                )
            ),
          );
        },

      ),
    );
  }
}