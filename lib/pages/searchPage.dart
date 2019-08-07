import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/hot_key_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/res/colors.dart';

import 'articleDetail.dart';

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

    getHttpByHoyKey();
  }

  void getHttpByHoyKey() async {
    try {
      var hotKeyResponse = await HttpUtil().post(Api.HOT_KEY);
      Map hotKeyMap = json.decode(hotKeyResponse.toString());
      var hotKeyEntity = HotKeyEntity.fromJson(hotKeyMap);

      setState(() {
        hotKeyDatas = hotKeyEntity.data;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: null,
    );
  }

  void getHttpByKey(String key) async {
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
  BuildContext get context => context;

  /// 搜索框右边的操作 返回的是一个Widget集合
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      FlatButton(
        child: Text(
          "搜索",
          style: TextStyle(fontSize: 18, color: YColors.color_fff),
        ),
        onPressed: () async {
          var data = {'k': query};
          var articleResponse = await HttpUtil().post(Api.QUERY, data: data);
          Map articleMap = json.decode(articleResponse.toString());
          var articleEntity = ArticleEntity.fromJson(articleMap);
          articleDatas = articleEntity.data.datas;

          showResults(context);
        },
      ),
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
  /// 源码
  ///     onSubmitted: (String _) {
  ///        widget.delegate.showResults(context);
  ///     },
  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: articleDatas.length,
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd) Divider();
          return GestureDetector(
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                    articleDatas[position]
                        .title
                        .replaceAll("<em class='highlight'>", "【")
                        .replaceAll("<\/em>", "】"),
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
                                width: 1.0),
                            borderRadius: BorderRadius.circular((20.0)), // 圆角度
                          ),
                          child: Text(articleDatas[position].superChapterName,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(articleDatas[position].author),
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
                        title: articleDatas[position]
                            .title
                            .replaceAll("<em class='highlight'>", "")
                            .replaceAll("<\/em>", ""),
                        url: articleDatas[position].link)),
              );
            },
          );
        });
  }

  /// 搜索建议 调用的话就不能返回null
  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "大家都在搜：",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: YColors.color_666),
          ),
          SizedBox(height: 10),
          Wrap(
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
                  onPressed: () async {
                    query = hotKeyDatas[index].name;
                    key = query;

                    /// 请求数据
                    var data = {'k': key};
                    var articleResponse =
                        await HttpUtil().post(Api.QUERY, data: data);
                    Map articleMap = json.decode(articleResponse.toString());
                    var articleEntity = ArticleEntity.fromJson(articleMap);

                    articleDatas = articleEntity.data.datas;

                    /// 显示结果
                    showResults(context);
                  },
                  elevation: 3,
                  backgroundColor: Color.fromARGB(
                    180,
                    Random().nextInt(255),
                    Random().nextInt(255),
                    Random().nextInt(255),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  /// 主题样式
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return Theme.of(context).copyWith(
      //主题色
      primaryColor: theme.primaryColor,
      //图标颜色
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      //状态栏
      primaryColorBrightness: Brightness.dark,
      //文字主题
      textTheme: TextTheme(
        title: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }
}
