import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/project_entity.dart';
import 'package:wanandroid_flutter/entity/project_list_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPagePageState();
  }
}

class _LoginPagePageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TabController controller; //tab控制器
  int _currentIndex = 0; //选中下标

  List<ProjectData> _datas = new List(); //tab集合
  List<ProjectListDataData> _listDatas = new List(); //内容集合

  var tabs = <Tab>[];
  String btnText = "立即登录";
  bool visible = true;

  @override
  void initState() {
    super.initState();
    tabs = <Tab>[
      Tab(text: "登录"),
      Tab(text: "注册"),
    ];

    //初始化controller并添加监听
    controller = TabController(length: tabs.length, vsync: this);
    controller.addListener(() => _onTabChanged());

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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: tabs.length,
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 150, left: 20, right: 20),
        decoration: new BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [YColors.colorAccent, YColors.colorPrimaryDark]),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              //TabBarIndicatorSize.label：indicator与文字同宽，TabBarIndicatorSize.tab：与tab同宽
              indicatorPadding: EdgeInsets.symmetric(vertical: -5),
              controller: controller,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 30),
              unselectedLabelColor: Colors.white54,
              unselectedLabelStyle: TextStyle(fontSize: 20),
              indicatorColor: Colors.white,
              //是否可滑动,false：tab宽度则等比，true：tab宽度则包裹item
              isScrollable: false,
              tabs: tabs.map((Tab choice) {
                return new Tab(
                  text: choice.text,
                );
              }).toList(),
              onTap: (int i) {
                setState(() {
                  if (0 == i) {
                    btnText = "立即登录";
                    visible = true;
                  } else {
                    btnText = "立即注册";
                    visible = false;
                  }
                });
              },
            ),
            body: new TabBarView(
              controller: controller,
              children: tabs.map((Tab choice) {
                return getTabBarView();
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTabBarView() {
    //可滑动布局，避免弹出键盘时会有溢出异常
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      obscureText: true, //是否显示密码类型
                      keyboardType: TextInputType.number, //键盘类型，即输入类型
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: '请输入账号',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: false,
                      keyboardType: TextInputType.number, //键盘类型，即输入类型
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: '请输入密码',
                      ),
                    ),
                    SizedBox(height: 20),
                    Offstage(
                      offstage: visible,
                      child: Column(
                        children: <Widget>[
                          TextField(
                            obscureText: false,
                            keyboardType: TextInputType.number, //键盘类型，即输入类型
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              labelText: '请确认密码',
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      onPressed: () {
                        YToast.show(msg: btnText);
                      },
                      elevation: 5,
                      highlightElevation: 10,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          gradient: LinearGradient(
                            colors: <Color>[
                              YColors.colorAccent,
                              YColors.colorPrimaryDark,
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          btnText,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
