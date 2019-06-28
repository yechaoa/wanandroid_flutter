import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/res/colors.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ArticleDataData> articleDatas = new List();

  ScrollController _scrollController;
  String key = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() {});

//    getHttp();
  }

  void getHttp() async {
    try {
      var data = {'k': "动画"};
      var articleResponse = await HttpUtil().post(Api.QUERY, data: data);
      Map articleMap = json.decode(articleResponse.toString());
      var articleEntity = new ArticleEntity.fromJson(articleMap);

      setState(() {
        articleDatas = articleEntity.data.datas;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
//      key.isEmpty
//          ?
      Center(
              child: Text("aaaaa"),
            )
//          : Column(
//              children: <Widget>[
//                ListView.builder(
//                    controller: _scrollController,
//                    shrinkWrap: true,
//                    itemCount: articleDatas.length,
//                    itemBuilder: (BuildContext context, int position) {
//                      if (position.isOdd) return new Divider();
//                      return getRow(position);
//                    }),
//              ],
//            ),
    );
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Container(
          padding: new EdgeInsets.all(10.0),
          child: new ListTile(
            leading: new Icon(Icons.android),
            title: new Text(
              articleDatas[i].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: new Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          color: YColors.colorPrimary, width: 1.0),
                      borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                    ),
                    child: new Text(articleDatas[i].superChapterName,
                        style: TextStyle(color: YColors.colorAccent)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: new Text(articleDatas[i].author),
                  ),
                ],
              ),
            ),
            trailing: new Icon(Icons.chevron_right),
          )),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new ArticleDetail(
                  title: articleDatas[i].title, url: articleDatas[i].link)),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
