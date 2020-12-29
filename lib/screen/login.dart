import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t/services/services_login.dart';
import 'store_info.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final GlobalKey<ScaffoldState> _loginFormKey = new GlobalKey<ScaffoldState>();
//////////////////////////////////////////////
  bool validatePass = false; ///////////////
  bool validatePassLength = false; //////////
  bool validateUserNameLength = false; ///////// this parameter bool to validate UserName and Password
  bool validateUserName = false; ////////////
  ///////////////////////////////////////
  bool _isHidden = true; ////////////////   this parameter boo to chick into icon button if checked or no
  Locale _locale; //////////////////////    this parameter to get Local Location
  String accessToken ; ////////     this parameter String to store AccessToken
  String tokenType; ///////////      this parameter String to store TokenType
  String tokenTypeCorrect; /////////       this parameter String to store TokenType after convert first char into toUpperCase and To combine it with the rest of String
  var dateTime = DateFormat(
      '+h'); //       this parameter to set DateFormat into +h
  var dateGMT ; //////////////        this parameter to store dateGMT
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();


  bool _isInAsyncCall = false;
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  showAlertDialog(BuildContext context, String title) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
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

  @override
  Widget build(BuildContext context) {
    _locale = Localizations.localeOf(context); // to ini _locale
    dateGMT = dateTime.format(DateTime.now().toUtc()); // to ini dateGMT
  //  return loading ? Center(child: CircularProgressIndicator()) : Scaffold(
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Login"),),
      body:ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: buildLoginForm(context),
          ),
        ),
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );


  }
  Widget buildLoginForm(BuildContext context){
  return Form(
    key: _formKey,
    child:SingleChildScrollView(
      child:    Padding(
        padding: const EdgeInsets.all(18.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextFormField(
              textAlign: TextAlign.center,
              controller: username,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter userName';
                }
                if (value.length < 3) {
                  return 'userName less than 3 chars ';

                }
                return null;
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.redAccent, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.deepOrange[900], width: 2.0),
                ),
                labelText: "UserName",
                labelStyle: TextStyle(
                    color: Colors.blueGrey
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),

            ),
            SizedBox(height: 5,),
            TextFormField(
              textAlign: TextAlign.center,
              controller: password,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter password';
                }
                if (value.length < 3) {
                  return 'password less than 3 chars';
                }
                return null;
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.redAccent, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.deepOrange[900], width: 2.0),
                ),
                labelText: "Password",
                labelStyle: TextStyle(
                    color: Colors.blueGrey
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
                suffixIcon: IconButton(
                  onPressed: _toggleVisibility,
                  icon: _isHidden ? Icon(
                    Icons.visibility_off, color: Colors.blueGrey,) : Icon(
                    Icons.visibility, color: Colors.blueGrey,),
                ),
              ),
              obscureText: _isHidden,
            ),
            SizedBox(height: 5,),
            Container(
              padding: const EdgeInsets.fromLTRB(20,7,20,7),
              child: Material(
                color: Colors.deepOrange[900],
                elevation: 6,
                borderRadius: BorderRadius.circular(30),
                child: MaterialButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid
                      setState(() {
                        _isInAsyncCall = true;
                      });
                      login(username.text,password.text,
                          _locale.toString(), dateGMT).then((value){
                        if(value['message'] !=null){
                          showAlertDialog(context,value['message']);
                        }else{
                          accessToken = value['access_token'].toString();
                          tokenType = value['token_type'].toString();
                          tokenTypeCorrect = tokenType.substring(0,1).toUpperCase()+ tokenType.substring(1,tokenType.length);
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StoreInfo( accessToken :accessToken , tokenType :tokenTypeCorrect)));
                        }
                      }).whenComplete(() {
                        setState(() {
                          _isInAsyncCall = false;
                        });
                      });
                    }
                  },
                  minWidth: (MediaQuery.of(context).size.width),
                  height: 45,
                  child: Text("LogIn" , style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20,7,20,7),
              child: Material(
                color: Colors.deepOrange[900],
                elevation: 6,
                borderRadius: BorderRadius.circular(30),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _isInAsyncCall = true;
                    });
                    setState(() {
                      loginanonymous(_locale.toString(), dateGMT).then((value) {
                        accessToken = value['access_token'].toString();
                        tokenType = value['token_type'].toString();
                        tokenTypeCorrect = tokenType.substring(0,1).toUpperCase()+ tokenType.substring(1,tokenType.length);
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StoreInfo( accessToken :accessToken , tokenType :tokenTypeCorrect)));
                      }).whenComplete(() {
                        setState(() {
                          _isInAsyncCall = false;
                        });
                      });
                    });
                  },
                  minWidth: (MediaQuery.of(context).size.width),
                  height: 45,
                  child: Text("LogIn Anonymous" , style: TextStyle(color: Colors.white),),

                ),
              ),
            ),


          ],
        ),
      ),



    ),
  );
  }

}
