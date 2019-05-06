import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/res/strings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(YStrings.home,
          style: TextStyle(fontSize: 50, color: Colors.red)),
    );
  }
}
