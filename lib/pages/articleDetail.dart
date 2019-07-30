import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provide/provide.dart';
import 'package:share/share.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/util/favoriteProvide.dart';

// ignore: must_be_immutable
class ArticleDetail extends StatelessWidget {
  String url, title;

  ArticleDetail({Key key, @required this.title, @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: YColors.colorPrimary,
        primaryColorDark: YColors.colorPrimaryDark,
      ),
      routes: {
        "/": (_) => new WebviewScaffold(
              url: "$url",
              appBar: new AppBar(
                //返回键 点击关闭
                leading: new IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                title: new Text("$title"),
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
                    icon: const Icon(Icons.share),
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
