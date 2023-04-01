import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/tree_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/treeDetailPage.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';

class TreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TreePageState();
  }
}

class _TreePageState extends State<TreePage> {
  List<TreeData> _datas = List();
  ScrollController _scrollController = ScrollController();
  int _panelIndex = 0; //展开下标
  List<IconData> _icons = [
    Icons.star_border,
    Icons.child_care,
    Icons.cloud_queue,
    Icons.ac_unit,
    Icons.lightbulb_outline,
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      //当前位置==最大滑动范围 表示已经滑动到了底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        YToast.show(context: context, msg: "滑动到了底部");
        // do something
        //getMoreData();
      }
    });

    getHttp();
  }

  void getHttp() async {
    try {
      var response = await HttpUtil().get(Api.TREE);
      Map userMap = json.decode(response.toString());
      var treeEntity = TreeEntity.fromJson(userMap);

      //遍历赋值isExpanded标识，默认全部合并
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
      body: RefreshIndicator(
        //指示器颜色
        color: Theme.of(context).primaryColor,
        //指示器显示时距顶部位置
        displacement: 40,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: ExpansionPanelList(
            //开关动画时长
            animationDuration: Duration(milliseconds: 500),
            //开关回调
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _panelIndex = panelIndex;
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
                    title: Text(
                      treeData.name,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    //取随机icon
                    leading: Icon(_icons[Random().nextInt(_icons.length)]),
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
                    },
                  ),
                ),
                //是否展开
                isExpanded: treeData.isExpanded,
              );
            }).toList(),
          ),
        ),
        //下拉刷新回调
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {
            YToast.show(context: context, msg: "下拉刷新");
            // do something
            //getData();
          });
        },
      ),
    );
  }

  Widget getRow(int i, TreeData treeData) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: ListTile(
          title: Text(
            treeData.children[i].name,
            style: TextStyle(color: YColors.color_999),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: YColors.color_999,
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TreeDetailPage(panelIndex: _panelIndex, index: i),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
