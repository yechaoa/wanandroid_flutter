import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wanandroid_flutter/res/colors.dart';

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
              // ignore: unnecessary_brace_in_string_interps
              url: "${url}",
              appBar: new AppBar(
                leading: new IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                // ignore: unnecessary_brace_in_string_interps
                title: new Text("${title}"),
              ),
            ),
      },
    );
  }
}
