import 'package:flutter/material.dart';
import 'package:t/services/services_get_location.dart';

class location_ extends StatefulWidget {
  @override
  _location_State createState() => _location_State();
  // This accessToken and tokenType contain the data coming from API and store the access token and token type from http.post
  String accessToken ;
  String tokenType ;
  location_({this.accessToken, this.tokenType});
}
class _location_State extends State<location_> {
  String idSelectCountry;// to store Id after Select Country
  String idSelectCity;// to store Id after Select City
  String idSelectDistrict;// to store Id after Select District

  final String url = "https://storeak-gps-service-beta.azurewebsites.net/api/v1/Locations";
  List cites = new List(); // this list to store data city after select Country
  List district = new List();// this list to store data District after select city
  List data = List(); // this list to store all data from api
  @override
  void initState() { // this ini to Initialize data from api
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body:FutureBuilder(
        future: getLocation(url ,widget.tokenType , widget.accessToken ),
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
                              child:  DropdownButton(
                                hint: Text("Country"),
                                items: data.map((item) {// this map that contain data from api to show Country
                                  return  DropdownMenuItem(
                                    child:  Text(item['name'].toString()), // this name that come back from list method of json
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
                                      idSelectCountry = newVal;
                                      for (int i=0;i<data.length;i++){
                                        if (data[i]['id'].toString()==idSelectCountry.toString()){
                                          cites=data[i]['children'];
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
                                      if (idSelectCountry!=newVal){
                                        idSelectCountry = newVal;
                                        idSelectCity = null;
                                        idSelectDistrict = null;
                                        if (district.isNotEmpty){
                                          district.clear();
                                        }
                                        // print(_mySelection.toString());
                                        for (int i=0;i<data.length;i++){
                                          if (data[i]['id'].toString()==idSelectCountry.toString()){
                                            cites=data[i]['children'];
                                            break;
                                          }
                                        }
                                      }

                                    }


                                    //print(data1[1]['children'][0]['name']);
                                  });
                                },
                                value: idSelectCountry,
                              ),
                            ),

                            cites.isEmpty?Expanded(
                              child: DropdownButton(
                                //To select a city and it displays a city if the country is not selected
                                  hint: Text("City")
                              ),
                            )
                                :new Expanded(child:DropdownButton(

                              hint: Text("City"),
                              items: cites.map((item) {
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
                                    idSelectCity = newVal;
                                    for (int i=0;i<cites.length;i++){
                                      if (cites[i]['id'].toString()==idSelectCity.toString()){
                                        district=cites[i]['children'];
                                        break;
                                      }
                                    }
                                  }else{
                                    /*
                              * To test whether the value we previously selected is the same or not,
                              * If she's the same here, she'd do nothing,
                              * But if not then this means that the region values should be blank if previously specified and data must be fetched
                              * */
                                    if (idSelectCity!=newVal){
                                      idSelectCity = newVal;
                                      idSelectDistrict = null;

                                      for (int i=0;i<cites.length;i++){
                                        if (cites[i]['id'].toString()==idSelectCity.toString()){
                                          district=cites[i]['children'];
                                          break;
                                        }
                                      }
                                    }
                                  }

                                });
                              },
                              value: idSelectCity,
                            )),

                            district.isEmpty?Expanded (
                              child: DropdownButton(
                                //To Selects the District and displays a city if the city is not selected
                                  hint: Text("District")
                              ),
                            )
                                : Expanded(child:DropdownButton(
                              hint: Text("District"),
                              items: district.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['name'].toString() ,),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  idSelectDistrict = newVal;
                                /*  print(Id_Select_Country.toString());
                                  print(Id_Select_City.toString());
                                  print(Id_Select_District.toString());*/
                                });
                              },
                              value: idSelectDistrict,
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