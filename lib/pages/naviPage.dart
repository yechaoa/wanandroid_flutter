import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/res/strings.dart';

class NaviPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(YStrings.navi, style: TextStyle(fontSize: 30,color: YColors.colorPrimary)),
    );
  }
}