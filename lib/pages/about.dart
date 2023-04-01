import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';

import 'articleDetail.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _list = <String>[
      "fluttertoast",
      "dio",
      "cookie_jar",
      "flutter_webview_plugin",
      "flutter_swiper",
      "share",
      "provide",
      "shared_preferences",
      "flutter_easyrefresh",
    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("关于项目"),
            expandedHeight: 230.0,
            floating: false,
            pinned: true,
            snap: false,
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz),
                offset: Offset(100, 100),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "1",
                    child: ListTile(
                      leading: Icon(Icons.share),
                      title: Text('分享'),
                    ),
                  ),
                  PopupMenuDivider(), //分割线
                  const PopupMenuItem<String>(
                    value: "2",
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('设置'),
                    ),
                  ),
                ],
                tooltip: "点击弹出菜单",
                onSelected: (String result) {
                  print(result);
                  switch (result) {
                    case "1":
                      //需要重启，不然会有 MissingPluginException(No implementation found for method getAll on channel plugins.flutter.io/share)异常
                      Share.share('【玩安卓Flutter版】\nhttps://github.com/yechaoa/wanandroid_flutter');
                      break;
                    case "2":
                      YToast.show(context: context, msg: "设置");
                      break;
                  }
                },
                onCanceled: () {
                  print("取消");
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              //background: Image.asset("images/a.jpg", fit: BoxFit.fill),
              background: Image.network(
                  "https://profile-avatar.csdnimg.cn/f81b97e9519148ac9d7eca7681fb8698_yechaoa.jpg!1",
                  // "https://avatars3.githubusercontent.com/u/19725223?s=400&u=f399a2d73fd0445be63ee6bc1ea4a408a62454f5&v=4",
                  fit: BoxFit.cover),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 900.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "wanandroid_flutter V2.0",
                        style: TextStyle(fontSize: 25, fontFamily: 'mononoki'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Author ：yechaoa",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("GitHub"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetail(
                                title: "别跑，点个star再走~🌹", url: "https://github.com/yechaoa/wanandroid_flutter"),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text("掘金"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetail(
                                title: "yechaoa's 掘金", url: "https://juejin.cn/user/659362706101735/posts"),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text("CSDN"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetail(
                                title: "yechaoa's CSDN", url: "https://blog.csdn.net/yechaoa"),
                          ),
                        );
                      },
                    ),
                    Divider(),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "用到的库：",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListView.builder(
                      itemCount: _list.length,
                      shrinkWrap: true,
                      //禁掉ListView的滑动，跟CustomScrollView滑动冲突
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int position) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          child: Text(
                            _list[position].toString(),
                            style: TextStyle(fontFamily: 'mononoki'),
                          ),
                        );
                      },
                    ),
                    Divider(),
                  ],
                ),
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
