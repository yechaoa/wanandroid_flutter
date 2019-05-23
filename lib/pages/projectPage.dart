import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/project_entity.dart';
import 'package:wanandroid_flutter/entity/project_list_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/res/colors.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ProjectPageState();
  }
}

class _ProjectPageState extends State<ProjectPage> with SingleTickerProviderStateMixin {

  TabController controller;//tab控制器
  int _currentIndex = 0; //选中下标

  List<ProjectData> _datas = new List();//tab集合
  List<ProjectListDataData> _listDatas = new List();//内容集合

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  void getHttp() async {
    try {
      var response = await HttpUtil().get(Api.PROJECT);
      Map userMap = json.decode(response.toString());
      var projectEntity = new ProjectEntity.fromJson(userMap);

      setState(() {
        if (_datas.length != null) _datas = projectEntity.data;
        _currentIndex = 0;
      });

      getDetail();

      //初始化controller并添加监听
      controller = TabController(length: _datas.length, vsync: this);
      controller.addListener(() => _onTabChanged());

    } catch (e) {
      print(e);
    }
  }

  ///
  /// tab改变监听
  ///
  _onTabChanged() {
    if (controller.indexIsChanging) {
      if (this.mounted) {
        //赋值 并更新数据
        this.setState(() {
          _currentIndex = controller.index;
        });
        getDetail();
      }
    }
  }

  ///
  /// 根据tab下标获取数据
  ///
  void getDetail() async {
    try {
      var data = {"cid": _datas[_currentIndex].id};
      var response = await HttpUtil().get(Api.PROJECT_LIST, data: data);
      Map userMap = json.decode(response.toString());
      var projectListEntity = new ProjectListEntity.fromJson(userMap);

      setState(() {
        _listDatas = projectListEntity.data.datas;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: _datas.length,
      child: new Scaffold(
        appBar: new TabBar(
          controller: controller,//控制器
          labelColor: YColors.colorPrimaryDark, //选中的颜色
          labelStyle: TextStyle(fontSize: 16), //选中的样式
          unselectedLabelColor: YColors.color_666, //未选中的颜色
          unselectedLabelStyle: TextStyle(fontSize: 14), //未选中的样式
          indicatorColor: YColors.colorPrimary, //下划线颜色
          isScrollable: true, //是否可滑动
          //tab标签
          tabs: _datas.map((ProjectData choice) {
            return new Tab(
              text: choice.name,
            );
          }).toList(),
          //点击事件
          onTap: (int i) {
            print(i);
          },
        ),
        body: new TabBarView(
          controller: controller,
          children: _datas.map((ProjectData choice) {
            return new ListView.builder(
                itemCount: _listDatas.length,
                itemBuilder: (BuildContext context, int position) {
                  return getRow(position);
                });
          }).toList(),
        ),
      ),
    );
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(10),
        child: new Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  flex: 2,
                  child: new Image.network(_listDatas[i].envelopePic),
                ),
                new Expanded(
                  flex: 5,
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: new Text(
                          _listDatas[i].title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.all(10),
                        child: new Text(
                          _listDatas[i].desc,
                          style:
                              TextStyle(fontSize: 14, color: YColors.color_666),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      new Container(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              flex: 1,
                              child: new Padding(
                                padding: EdgeInsets.all(10),
                                child: new Text(_listDatas[i].niceDate,
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(10),
                              child: new Text(
                                _listDatas[i].author,
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        //点击item跳转到详情
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new ArticleDetail(
                  title: _listDatas[i].title, url: _listDatas[i].link)),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
