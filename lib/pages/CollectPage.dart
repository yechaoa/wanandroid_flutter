import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/common_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';
import 'package:wanandroid_flutter/widget/my_phoenix_footer.dart';
import 'package:wanandroid_flutter/widget/my_phoenix_header.dart';

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
  int _page = 0;

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  void getHttp() async {
    try {
      var response = await HttpUtil().get(Api.COLLECT_LIST + "$_page/json");
      Map map = json.decode(response.toString());
      var articleEntity = ArticleEntity.fromJson(map);

      if (articleEntity.errorCode == -1001) {
        YToast.show(context: context, msg: articleEntity.errorMsg);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
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
      body: EasyRefresh.custom(
        header: PhoenixHeader(),
        footer: PhoenixFooter(),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _page = 0;
            });
            getHttp();
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 1), () async {
            setState(() {
              _page++;
            });
            getMoreData();
          });
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return getItem(index);
              },
              childCount: articleDatas.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget getItem(int index) {
    final item = articleDatas[index];
    return Dismissible(
      // Show a red background as the item is swiped away
      background: Container(color: Theme.of(context).primaryColor),
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify Widgets.
      key: Key(item.title),
      // We also need to provide a function that will tell our app
      // what to do after an item has been swiped away.
      onDismissed: (direction) {
        // Remove the item from our data source
        articleDatas.removeAt(index);

        cancelCollect(item.id, item.originId == null ? -1 : item.originId);

        // Show a snackbar! This snackbar could also contain "Undo" actions.
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("已移除")));
      },
      child: getRow(index),
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

  Future getMoreData() async {
    var response = await HttpUtil().get(Api.COLLECT_LIST + "$_page/json");
    Map map = json.decode(response.toString());
    var articleEntity = ArticleEntity.fromJson(map);
    setState(() {
      articleDatas.addAll(articleEntity.data.datas);
    });
  }
}
