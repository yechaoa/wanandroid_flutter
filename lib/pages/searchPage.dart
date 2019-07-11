import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/hot_key_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/res/colors.dart';

List<ArticleDataData> articleDatas = List();
List<HotKeyData> hotKeyDatas = List();
String key = "";
var pageContext;

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();

    getHttp();
  }

  void getHttp() async {
    try {
      var hotKeyResponse = await HttpUtil().post(Api.HOT_KEY);
      Map hotKeyMap = json.decode(hotKeyResponse.toString());
      var hotKeyEntity = HotKeyEntity.fromJson(hotKeyMap);

      var data = {'k': key};
      var articleResponse = await HttpUtil().post(Api.QUERY, data: data);
      Map articleMap = json.decode(articleResponse.toString());
      var articleEntity = ArticleEntity.fromJson(articleMap);

      setState(() {
        hotKeyDatas = hotKeyEntity.data;
        articleDatas = articleEntity.data.datas;
      });

      //3个参数：上下文，搜索代理，关键词,其中前两个必传，query可选
      showSearch(context: context, delegate: MySearchDelegate());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    pageContext = context;
    return new Scaffold(
      backgroundColor: Colors.white,
      body: null,
    );
  }

  void getHttpByKey() async {
    try {
      var data = {'k': key};
      var articleResponse = await HttpUtil().post(Api.QUERY, data: data);
      Map articleMap = json.decode(articleResponse.toString());
      var articleEntity = ArticleEntity.fromJson(articleMap);

      setState(() {
        articleDatas = articleEntity.data.datas;
      });
    } catch (e) {
      print(e);
    }
  }
}

class MySearchDelegate extends SearchDelegate<String> {
  /// 搜索框右边的操作 返回的是一个Widget集合
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // 显示一个清除的按钮
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  /// 搜索框左边的操作，一般是返回按钮
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
        Navigator.of(pageContext).pop();
      },
    );
  }

  /// 搜索结果
  @override
  Widget buildResults(BuildContext context) {
    return Text("搜索结果a");
  }

  /// 搜索建议 调用的话就不能返回null
  @override
  Widget buildSuggestions(BuildContext context) {
    return Wrap(
      spacing: 10.0, //两个widget之间横向的间隔
      direction: Axis.horizontal, //方向
      alignment: WrapAlignment.start, //内容排序方式
      children: List<Widget>.generate(
        hotKeyDatas.length,
        (int index) {
          return ActionChip(
            //标签文字
            label: Text(
              hotKeyDatas[index].name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            //点击事件
            onPressed: () {
              query = hotKeyDatas[index].name;
              key = query;

              /// 请求数据
              showResults(context);
            },
            elevation: 3,
            backgroundColor: Color.fromARGB(180, Random().nextInt(255),
                Random().nextInt(255), Random().nextInt(255)),
          );
        },
      ).toList(),
    );
  }

  /// 主题样式
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return Theme.of(context).copyWith(
      primaryColor: YColors.colorPrimary,
      //主题色
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      //图标颜色
      primaryColorBrightness: Brightness.dark,
      //状态栏
      hintColor: Colors.amber,
      highlightColor: Colors.amberAccent,
      cursorColor: Colors.amber,
      textTheme: TextTheme(
          title: TextStyle(color: Colors.white, fontSize: 20.0)), //文字主题
    );
  }
}
