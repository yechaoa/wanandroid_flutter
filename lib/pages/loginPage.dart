import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/user_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/main.dart';
import 'package:wanandroid_flutter/res/colors.dart';
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
  String btnText = "登录";
  String bottomText = "没有账号？注册";
  String f = "没有账号？注册";
  bool visible = true;
  GlobalKey<FormState> _key = GlobalKey();
  bool autoValidate = false;
  String username, password, rePassword;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Theme.of(context).accentColor,
        primaryColorDark: Theme.of(context).primaryColorDark,
      ),
      home: Container(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: getBodyView(),
        ),
      ),
    );
  }

  Widget getBodyView() {
    //可滑动布局，避免弹出键盘时会有溢出异常
    return ListView(
      children: <Widget>[
        SizedBox(height: 80),
        Stack(alignment: Alignment.topCenter, children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.all(40),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
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
                        //键盘类型，即输入类型
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person_outline),
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
                        //是否显示密码类型
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline),
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
                                icon: Icon(Icons.lock_outline),
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
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("lib/res/images/ic_logo.png"),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 130,
            right: 130,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
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
          ),
        ]),
        GestureDetector(
          child: Text(
            bottomText,
            style: TextStyle(color: YColors.color_fff),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            setState(() {
              if (visible) {
                btnText = "注册";
                visible = false;
                bottomText = "已有账号？登录";
              } else {
                btnText = "登录";
                visible = true;
                bottomText = "没有账号？注册";
              }
            });
          },
        ),
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
