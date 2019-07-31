import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provide/provide.dart';
import 'package:share/share.dart';
import 'package:wanandroid_flutter/util/favoriteProvide.dart';

// ignore: must_be_immutable
class ArticleDetail extends StatelessWidget {
  String url, title;

  ArticleDetail({Key key, @required this.title, @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Theme.of(context).primaryColor,
      ),
      routes: {
        "/": (_) => new WebviewScaffold(
              url: "$url",
              appBar: AppBar(
                //返回键 点击关闭
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                title: Text("$title"),
                actions: <Widget>[
                  Provide<FavoriteProvide>(
                    builder: (context, child, favorite) {
                      return IconButton(
                        icon: Provide.value<FavoriteProvide>(context).value
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        tooltip: '收藏',
                        onPressed: () {
                          Provide.value<FavoriteProvide>(context)
                              .changeFavorite(
                                  !Provide.value<FavoriteProvide>(context)
                                      .value);
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    tooltip: '分享',
                    onPressed: () {
                      Share.share('【$title】\n$url');
                    },
                  ),
                ],
              ),
            ),
      },
    );
  }
}
