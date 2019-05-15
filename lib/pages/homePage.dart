import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/res/colors.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ArticleDataData> _datas = new List();

  @override
  void initState() {
    super.initState();

    getHttp();
  }

  void getHttp() async {
    try {
      Response response = await Dio().get("https://www.wanandroid.com/article/list/1/json");
      Map userMap = json.decode(response.toString());
      var articleEntity = new ArticleEntity.fromJson(userMap);
      print('------------------- ${articleEntity.data.datas[0].title}!');

      var response1=await HttpUtil().get(Api.ARTICLE_LIST);
      print('------------------- '+response1.toString());

      setState(() {
        _datas = articleEntity.data.datas;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new ListView.builder(
            itemCount: _datas.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            }));
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Container(
          padding: new EdgeInsets.all(15.0),
          child: new ListTile(
            leading: new Icon(Icons.android),
            title: new Text(_datas[i].title),
            subtitle: new Row(
              children: <Widget>[
                new Text(_datas[i].superChapterName,
                    style: TextStyle(color: YColors.colorAccent)),
                new Text("      " + _datas[i].author),
              ],
            ),
            trailing: new Icon(Icons.chevron_right),
          )),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new ArticleDetail(
                  title: _datas[i].title, url: _datas[i].link)),
        );
      },
    );
  }
}
