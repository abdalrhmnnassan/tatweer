
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t/screen/location.dart';
import 'package:t/services/get_store_info.dart';
import '../model/Store_Info.dart';


class StoreInfo extends StatefulWidget {

  // This Accesss_Token and Token_type contain the data coming from API and store the access token and token type from http.post
  String Accesss_Token  = "";
  String Token_type  = "";
  StoreInfo({this.Accesss_Token, this.Token_type});
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Location_( Accesss_Token :widget.Accesss_Token , Token_type :widget.Accesss_Token)));

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
              future: getStoreInfo(url, widget.Token_type, widget.Accesss_Token ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child:  CircularProgressIndicator(backgroundColor:  Colors.red,),);
                }
                //instance of Store object
                Store_Info store = Store_Info.fromJson(snapshot.data);
                return TabBarView(
                  children: [
                    // this function to build Main store body
                    Main_Store_Tab(store),
                    // this function to build branches stores body
                    Other_Stores_Tab(store),
                  ],
                );
              }),
        ),
      ),
    );
  }




  Main_Store_Tab(Store_Info store) {
    return Container(
      child: Card(
        child: Column(
          children: [
            Expanded(child: CachedNetworkImage(
              imageUrl: store.mainStore.picturePath,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator( value: downloadProgress.progress , backgroundColor:  Colors.deepOrange[900],),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),),
            Text(store.mainStore.description.toString()),
            Text(store.mainStore.freeNumber.toString())
          ],

        ),
      ),
    );


    /* return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(store.mainStore.picturePath),),
      title: Text(store.mainStore.name),
      subtitle: Text(store.mainStore.description.toString()),
      trailing: Text(store.mainStore.freeNumber.toString()),
    );*/

  }

  Other_Stores_Tab(Store_Info store) {
    final orientation = MediaQuery.of(context).orientation;
    return   GridView.builder(
      itemCount: store.countriesBranches[0].citiesBranches[0].branches.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: new Card(
            child: Column(
              children: [
                Expanded(child: CachedNetworkImage(
                  imageUrl: store.countriesBranches[0].citiesBranches[0].branches[index].picturePath,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress ,  backgroundColor:  Colors.deepOrange[900],),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),),
                Container(
                  child:Text(store.countriesBranches[0].citiesBranches[0].branches[index].name,style: TextStyle(fontSize: 20),) ,
                ),  Container(
                  child:Text(store.countriesBranches[0].citiesBranches[0].branches[index].description.toString(),style: TextStyle(fontSize: 15),) ,
                ),  Container(
                  child:Text(store.countriesBranches[0].citiesBranches[0].branches[index].freeNumber.toString(),style: TextStyle(fontSize: 15),) ,
                ),
              ],
            ),
          ),
        );
      },
    );

    /*  return ListView.builder(
      itemBuilder: (_,index){
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(store.countriesBranches[0].citiesBranches[0].branches[index].picturePath),),
          title: Text(store.countriesBranches[0].citiesBranches[0].branches[index].name),
          subtitle: Text(store.countriesBranches[0].citiesBranches[0].branches[index].description.toString()),
          trailing: Text(store.countriesBranches[0].citiesBranches[0].branches[index].freeNumber.toString()),
        );
      },
      itemCount:store.countriesBranches[0].citiesBranches[0].branches.length,
    );*/
  }
}