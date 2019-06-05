import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';

class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CollectPagePageState();
  }
}

class _CollectPagePageState extends State<CollectPage> {
  FocusNode userFocusNode = FocusNode();

  var controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                autofocus: true,
                obscureText: false,
                enabled: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                cursorColor: Colors.orange,
                cursorWidth: 5,
                maxLines: 1,
                maxLength: 8,
                style: TextStyle(fontSize: 20),
                focusNode: userFocusNode,
                controller: controller,
                onChanged: (text) {
                  print("输入改变时" + text);
                },
                onEditingComplete: () {
                  print("输入完成");
                },
                onSubmitted: (text) {
                  print("提交时" + text);
                },
                onTap: () {
                  print("点击了");
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  prefixIcon: Icon(Icons.phone_android),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        //controller.text = "";
                        controller.clear();
                      }),
                  hintText: '请输入账号aaa',
                  labelText: '请输入账号',
                  helperText: "请输入账号",
                  helperStyle: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                onPressed: () {
                  userFocusNode.unfocus(); //清除焦点，即隐藏键盘

                  //简单模拟校验
                  validateName(controller.text);

                  //controller.text 也可以获取输入内容
                  YToast.show(msg: "登录" + controller.text);
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
                    "登录",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return "请输入账号哦";
    }
    return null;
  }
}
