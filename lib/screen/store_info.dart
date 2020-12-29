
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t/screen/location.dart';
import 'package:t/services/services_get_store_info.dart';
import '../model/Store_Info.dart';


class StoreInfo extends StatefulWidget {

  // This accessToken and tokenType contain the data coming from API and store the access token and token type from http.post
  String accessToken  = "";
  String tokenType  = "";
  StoreInfo({this.accessToken, this.tokenType});
  @override
  _StoreInfoState createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {

  String url = 'https://storeak-stores-service-beta.azurewebsites.net/api/v1/Stores/Info/StoreAndBranchesOrderedByAddresses';
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme:  ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.deepOrange[900],
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
             actions: [
             IconButton(
                icon: Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => location_( accessToken :widget.accessToken , tokenType :widget.tokenType)));

                },
              )
            ],
            backgroundColor: Colors.red,

            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Main Store',
                ),
                Tab(
                  text: 'Branches',
                ),
              ],
            ),
            title: Text('Store Info'),
          ),
          body: FutureBuilder(
            // this method come back from getStoreInfo file in the services package,
              future: getStoreInfo(url, widget.tokenType, widget.accessToken ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child:  CircularProgressIndicator(backgroundColor:  Colors.red,),);
                }
                //instance of Store object
                Store_Info store = Store_Info.fromJson(snapshot.data);
                return TabBarView(
                  children: [
                    // this function to build Main store body
                    mainStoreTab(store),

                    // this function to build branches stores body
                    otherStoresTab(store),
                  ],
                );
              }),
        ),
      ),
    );
  }




  mainStoreTab(Store_Info store) {
    return Container(
      child: Card(
        child: Column(
          children: [
            Expanded(child: CachedNetworkImage(
              imageUrl: store.mainStore.picturePath,
             placeholder: (context , url)=> Center(
               child: SizedBox(
                 width: 50,
                 height: 50,
                 child:  CircularProgressIndicator(),
               ),
             ),
             // progressIndicatorBuilder: (context, url, downloadProgress) =>
              //    LinearProgressIndicator( value: downloadProgress.progress , backgroundColor:  Colors.deepOrange[900],),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),),
            Text(store.mainStore.description.toString()),
            Text(store.mainStore.freeNumber.toString())
          ],

        ),
      ),
    );
  }

  otherStoresTab(Store_Info store){
     return ListView(
     children: [
       for(var i=0; i<store.countriesBranches.length;i++)
       for(var y=0; y<store.countriesBranches[i].citiesBranches.length;y++)
       for(var x=0; x<store.countriesBranches[i].citiesBranches[y].branches.length;x++)
         Container(
           child: new Card(
             child: Column(
               children: [
                 CachedNetworkImage(
                   imageUrl: store.countriesBranches[i].citiesBranches[y].branches[x].picturePath,
                   placeholder: (context , url)=> Center(
                     child: CircularProgressIndicator(),
                   ),
                   errorWidget: (context, url, error) => Icon(Icons.error),
                 ),
                 Container(
                   child:Text(store.countriesBranches[i].citiesBranches[y].branches[x].name,style: TextStyle(fontSize: 20),) ,
                 ),  Container(
                   child:Text(store.countriesBranches[i].citiesBranches[y].branches[x].description.toString(),style: TextStyle(fontSize: 15),) ,
                 ),  Container(
                   child:Text(store.countriesBranches[i].citiesBranches[y].branches[x].freeNumber.toString(),style: TextStyle(fontSize: 15),) ,
                 ),
               ],
             ),
           ),
         )
     ],
     );
  }

}