import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/tree_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/res/colors.dart';

class TreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TreePageState();
  }
}

class _TreePageState extends State<TreePage> {
  List<TreeData> _datas = new List();

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  void getHttp() async {
    try {
      var response = await HttpUtil().get(Api.TREE);
      Map userMap = json.decode(response.toString());
      var treeEntity = new TreeEntity.fromJson(userMap);
      print('------------------- ${treeEntity.data[0].name}');

      //遍历赋值isExpanded标识
      for (int i = 0; i < treeEntity.data.length; i++) {
        treeEntity.data[i].isExpanded = false;
      }

      setState(() {
        _datas = treeEntity.data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          //开关动画时长
          animationDuration: Duration(milliseconds: 500),
          //开关回调
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              _datas[panelIndex].isExpanded = !isExpanded;
            });
          },
          //内容区
          children: _datas.map<ExpansionPanel>((TreeData treeData) {
            return ExpansionPanel(
              //标题
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text(treeData.name),
                );
              },
              //展开内容
              body: Container(
                height: 200,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: ListView.builder(
                    itemCount: treeData.children.length,
                    itemBuilder: (BuildContext context, int position) {
                      return getRow(position, treeData);
                    }),
              ),
              //是否展开
              isExpanded: treeData.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget getRow(int i, TreeData treeData) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: ListTile(
            title: Text(treeData.children[i].name,
                style: TextStyle(color: YColors.color_999)),
            trailing: Icon(
              Icons.chevron_right,
              color: YColors.color_999,
            ),
          )),
      onTap: () {
        print(treeData.children[i].name);

        Fluttertoast.showToast(
            msg: treeData.children[i].name,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      },
    );
  }
}
