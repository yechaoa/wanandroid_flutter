import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/common_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';

import 'articleDetail.dart';
import 'loginPage.dart';

class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectPagePageState();
  }
}

class _CollectPagePageState extends State<CollectPage> {
  List<ArticleDataData> articleDatas = List();

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  void getHttp() async {
    try {
      var response = await HttpUtil().get(Api.COLLECT_LIST);
      Map map = json.decode(response.toString());
      var articleEntity = ArticleEntity.fromJson(map);

      print(response);

      if (articleEntity.errorCode == -1001) {
        YToast.show(context: context, msg: articleEntity.errorMsg);
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new LoginPage()),
        );
      } else {
        setState(() {
          articleDatas = articleEntity.data.datas;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: articleDatas.length,
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd) Divider();
          final item = articleDatas[position];
          return Dismissible(
            // Show a red background as the item is swiped away
            background: new Container(color: Theme.of(context).primaryColor),
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify Widgets.
            key: new Key(item.title),
            // We also need to provide a function that will tell our app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from our data source
              articleDatas.removeAt(position);

              cancelCollect(
                  item.id, item.originId == null ? -1 : item.originId);

              // Show a snackbar! This snackbar could also contain "Undo" actions.
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("已移除")));
            },
            child: getRow(position),
          );
        },
      ),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(
              articleDatas[i].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular((20.0)), // 圆角度
                    ),
                    child: Text(
                      articleDatas[i].chapterName,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(articleDatas[i].author),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right),
          )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetail(
                  title: articleDatas[i].title,
                  url: articleDatas[i].link,
                ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future cancelCollect(int id, int originId) async {
    var data = {'originId': originId};
    var collectResponse =
        await HttpUtil().post(Api.UN_COLLECT + '$id/json', data: data);
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
    } else {
      //getHttp();
    }
  }
}
