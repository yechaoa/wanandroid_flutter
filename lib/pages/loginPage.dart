import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/user_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/main.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPagePageState();
  }
}

class _LoginPagePageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TabController controller; //tab控制器

  var tabs = <Tab>[];
  String btnText = "立即登录";
  bool visible = true;
  GlobalKey<FormState> _key = GlobalKey();
  bool autoValidate = false;
  String username, password, rePassword;

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
  }

  ///
  /// tab改变监听
  ///
  _onTabChanged() {
    if (controller.indexIsChanging) {
      if (this.mounted) {
        //赋值 并更新数据
        setState(() {
          if (0 == controller.index) {
            btnText = "立即登录";
            visible = true;
          } else {
            btnText = "立即注册";
            visible = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Theme.of(context).accentColor,
        primaryColorDark: Theme.of(context).primaryColorDark,
      ),
      home: DefaultTabController(
        length: tabs.length,
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 120, left: 20, right: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColorDark,
              ],
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: TabBar(
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
                  return Tab(
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
              body: TabBarView(
                controller: controller,
                children: tabs.map((Tab choice) {
                  return getTabBarView();
                }).toList(),
              ),
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
              child: Form(
                autovalidate: autoValidate,
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      //键盘类型，即输入类型
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: '请输入账号',
                      ),
                      validator: validateUsername,
                      onSaved: (text) {
                        setState(() {
                          username = text;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      //是否显示密码类型
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: '请输入密码',
                      ),
                      validator: validatePassword,
                      onSaved: (text) {
                        setState(() {
                          password = text;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Offstage(
                      offstage: visible,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              labelText: '请确认密码',
                            ),
                            validator: visible ? null : validateRePassword,
                            onSaved: (text) {
                              setState(() {
                                rePassword = text;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
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
                              Theme.of(context).accentColor,
                              Theme.of(context).primaryColorDark,
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          btnText,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      onPressed: () {
                        if (_key.currentState.validate()) {
                          _key.currentState.save();
                          print(username + "--" + password + "**" + rePassword);
                          doRequest();
                        } else {
                          setState(() {
                            autoValidate = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
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

  String validateUsername(String value) {
    if (value.isEmpty)
      return "账号不能为空";
    else if (value.length < 6) return "账号最少6位";
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty)
      return "密码不能为空";
    else if (value.length < 6) return "密码最少6位";
    return null;
  }

  String validateRePassword(String value) {
    if (value.isEmpty)
      return "确认密码不能为空";
    else if (value.length < 6) return "确认密码最少6位";
//    else if (value != password) return "两次密码不一致";
    return null;
  }

  Future doRequest() async {
    var data;
    if (visible)
      data = {'username': username, 'password': password};
    else
      data = {
        'username': username,
        'password': password,
        'repassword': rePassword
      };

    var response =
        await HttpUtil().post(visible ? Api.LOGIN : Api.REGISTER, data: data);
    Map userMap = json.decode(response.toString());
    var userEntity = UserEntity.fromJson(userMap);
    if (userEntity.errorCode == 0) {
      YToast.show(context: context, msg: visible ? "登录成功~" : "注册成功~");
      //跳转并关闭当前页面
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (route) => route == null,
      );
    } else
      YToast.show(context: context, msg: userMap['errorMsg']);
  }
}
