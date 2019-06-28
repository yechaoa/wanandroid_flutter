import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/res/colors.dart';

/// 搜索类型为String
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
      },
    );
  }

  /// 搜索结果
  @override
  Widget buildResults(BuildContext context) {
    return Text("搜索结果");
  }

  /// 搜索建议 调用的话就不能返回null
  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Text("搜索建议"),
          Text("搜索建议"),
        ],
      ),
    );
  }

//  Future<List<ArticleDataData>> getData() async {
//    var data = {'k': "动画"};
//    var articleResponse = await HttpUtil().post(Api.QUERY, data: data);
//    Map articleMap = json.decode(articleResponse.toString());
//    var articleEntity = new ArticleEntity.fromJson(articleMap);
//    return articleEntity.data.datas;
//  }

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
