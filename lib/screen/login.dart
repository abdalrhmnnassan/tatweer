import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'file:///C:/AndroidStudio/fluttre_project/tatweer/lib/screen/store_info.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
//////////////////////////////////////////////
  bool _validate_pass = false;///////////////
  bool _validate_pass_len = false;//////////
  bool _validate_name_len = false;///////// this parameter bool to validate UserName and Password
  bool _validate_user = false;////////////
  ///////////////////////////////////////
  bool _isHidden = true;////////////////   this parameter boo to chick into icon button if checked or no
  Locale _locale;//////////////////////    this parameter to get Local Location
  String Accesss_Token = null;////////     this parameter String to store AccessToken
  String Token_type= null;///////////      this parameter String to store TokenType
  String Token_type_= null;/////////       this parameter String to store TokenType after convert first char into toUpperCase and To combine it with the rest of String
  var dateTime = DateFormat('+h');//       this parameter to set DateFormat into +h
  var dateGMT = null;//////////////        this parameter to store dateGMT
  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
          });
  }
  showAlertDialog(BuildContext context , String title) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context); },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Opps"),
      content: Text(title),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  // this function to login with the correct UserName and Password by API
  void LogIn() async {

    const url = "https://storeak-identity-service-beta.azurewebsites.net/api/v1/token";
    var body = jsonEncode({ //jsonEncode encodes a given value to a string using JSON syntax
      "Username"	  : "$username", // To set the UserName after fetching it from the interface
      "Password": "$password",/////// To set the Password after fetching it from the interface
      "PlayerId" : "" ,
      "Language" : '${_locale.toString().substring(0,2)}',// to set language phone and sub into tow char ex:en, ar
      "GMT" : "$dateGMT" , ///////// To set the time at which a user is registered
      "IsFromNotification" : "false"  // to set notification true or false if user open app on notification or no
          });
    http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body).then((http.Response response){
      var data = jsonDecode(response.body);  // To store data that comes from JSON
      if (response.statusCode != 200){
        showAlertDialog(context,data['message']); // If the username or password is incorrect, a AlertDialog appears
      }
    });
  }
  // this function to login without UserName and Password by API
  void LogInAnonymous() async {
    const url = "https://storeak-identity-service-beta.azurewebsites.net/api/v1/token";
    var body = jsonEncode({
      "clientId"	  : "14a20059-8baf-4b91-80e7-946cb6ea12fe",
      "clientSecret": "ddlfg543lk66nmxsmdcfvKLMdsxfg456Mkd",
      "PlayerId" : "" ,
      "Language" : '${_locale.toString().substring(0,2)}',
      "GMT" : "$dateGMT" ,
      "IsFromNotification" : "false"
          });
    http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body).then((http.Response response){
      if (response.statusCode == 200){
        var data = jsonDecode(response.body);
        Accesss_Token = data['access_token'].toString();
        Token_type = data['token_type'].toString();
        Token_type_ = Token_type.substring(0,1).toUpperCase()+ Token_type.substring(1,Token_type.length);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StoreInfo( Accesss_Token :Accesss_Token , Token_type :Token_type_)));
      }else{
        print(response.statusCode);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    _locale = Localizations.localeOf(context); // to ini _locale
    dateGMT = dateTime.format(DateTime.now().toUtc()); // to ini dateGMT
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Login"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              buildTextField("UserName" , username),
              SizedBox(height: 10,),
              buildTextField("Password" , password),
              CustomeButtone(
                text: "Log In",
                callback: () {
                  setState(() {
                    if (username.text.isEmpty ==true){
                      _validate_user = true;
                    } else if(password.text.isEmpty ==true){
                      _validate_pass = true;
                    }else if(password.text.length<3){
                      _validate_pass_len = true;
                    }else if(username.text.length<3){
                      _validate_name_len = true;
                    } else{
                      _validate_user = false;
                      _validate_pass = false;
                      _validate_pass_len = false;
                      _validate_name_len = false;
                    LogIn();
                    }
                  });
                },
              ),   // login button
              CustomeButtone(
                text: "Log In Anonymous",
                callback: () {
                  setState(() { LogInAnonymous();
                  });
                },
              ),  // login Anonymous button
            ],
          ),
        ),
      ),
    );
  }
  // this widget to build TextField
  Widget buildTextField(String hintText ,TextEditingController controller){
    return TextField(
      textAlign: TextAlign.center,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrange[900], width: 2.0),
        ),
        labelText: hintText,
        labelStyle: TextStyle(
            color: Colors.blueGrey
        ),
        hintStyle: TextStyle(

          color: Colors.grey,
          fontSize: 16.0,

        ),
        suffixIcon: hintText == "Password" ? IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden ? Icon(Icons.visibility_off , color: Colors.blueGrey,) : Icon(Icons.visibility ,color: Colors.blueGrey,),
        ) : null,
        errorText: _validate_pass && hintText == "Password" ? 'Value Can\'t Be Empty' : _validate_pass_len && hintText == "Password" ? "password less than 3 chars " : _validate_user ? 'Value Can\'t Be Empty' : _validate_name_len ? "password less than 3 chars " : null,
      ),
      obscureText: hintText == "Password" ? _isHidden : false,
    );
  }


}
// this class to build CustomeButtone
class CustomeButtone extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomeButtone({ Key key,this.callback, this.text}):super (key: key);
  // TODO: implement key
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20,7,20,7),
      child: Material(
        color: Colors.deepOrange[900],
        elevation: 6,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: callback,
          minWidth: (MediaQuery.of(context).size.width),
          height: 45,
          child: Text(text , style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}