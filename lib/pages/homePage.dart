import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List widgets = [];
  String str = "123";
  String name = "123";
  String nick_name = "123";
  String github = "123";

  @override
  void initState() {
    super.initState();

    getHttp();
  }

  void getHttp() async {
    try {
      Response response = await Dio().get("https://api.hencoder.com/author");
      print(response);
      Map<String, dynamic> user = json.decode(response.toString());

      print('Howdy, ${user['name']}!');
      print('We sent the verification link to ${user['github']}.');

      setState(() {
        str = response.toString();
        name=user['name'];
        nick_name=user['nick_name'];
        github=user['github'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Padding(padding: new EdgeInsets.all(15.0), child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
            new Text(nick_name),
            new Text(github),
          ],
        )),
        new Padding(padding: new EdgeInsets.all(10.0), child: new Text(str)),
        new Padding(padding: new EdgeInsets.all(10.0), child: new Text(str)),
      ],
    );
  }

  Widget getRow(int i) {
    return new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text("Row ${widgets[i]["name"]}"));
  }

}
