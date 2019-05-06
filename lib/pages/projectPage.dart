import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/res/strings.dart';

class ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(YStrings.project,
          style: TextStyle(fontSize: 30, color: Colors.blue)),
    );
  }
}
