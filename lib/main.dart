import 'dart:html';

import 'package:flutter/material.dart';
import 'file:///C:/AndroidStudio/fluttre_project/tatweer/lib/screen/store_info.dart';

import 'screen/login.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.red,

      ),
      home: Login(),
    );
  }
}

