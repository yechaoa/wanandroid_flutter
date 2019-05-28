import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_flutter/pages/homePage.dart';
import 'package:wanandroid_flutter/pages/naviPage.dart';
import 'package:wanandroid_flutter/pages/projectPage.dart';
import 'package:wanandroid_flutter/pages/treePage.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/res/strings.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: YStrings.appName,
      theme: ThemeData(
        // This is the theme of your application.

//        primarySwatch: Colors.blue,
        primaryColor: YColors.colorPrimary,
        primaryColorDark: YColors.colorPrimaryDark,
        accentColor: YColors.colorAccent,
        dividerColor: YColors.dividerColor,
      ),
      home: MyHomePage(title: YStrings.appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String title = YStrings.appName;

  var _pageController = new PageController(initialPage: 0);

  var pages = <Widget>[
    HomePage(),
    TreePage(),
    NaviPage(),
    ProjectPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: new PageView.builder(
        onPageChanged: _pageChange,
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (BuildContext context, int index) {
          return pages.elementAt(_selectedIndex);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text(YStrings.home)),
          BottomNavigationBarItem(
              icon: Icon(Icons.filter_list), title: Text(YStrings.tree)),
          BottomNavigationBarItem(
              icon: Icon(Icons.low_priority), title: Text(YStrings.navi)),
          BottomNavigationBarItem(
              icon: Icon(Icons.apps), title: Text(YStrings.project)),
        ],
        currentIndex: _selectedIndex,
        //当前选中下标
        type: BottomNavigationBarType.fixed,
        //显示模式
        fixedColor: YColors.colorPrimary,
        //选中颜色
        onTap: _onItemTapped, //点击事件
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showToast,
        tooltip: '点击选中最后一个',
        child: Icon(Icons.add, color: Colors.white),
      ),
      drawer: showDrawer(),
    );
  }

  void _onItemTapped(int index) {
    //bottomNavigationBar 和 PageView 关联
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _pageChange(int index) {
    setState(() {
      _selectedIndex = index;
      //根据下标修改标题
      switch (index) {
        case 0:
          title = YStrings.appName;
          break;
        case 1:
          title = YStrings.tree;
          break;
        case 2:
          title = YStrings.navi;
          break;
        case 3:
          title = YStrings.project;
          break;
      }
    });
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "选中最后一个",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: YColors.colorPrimaryDark,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    _onItemTapped(3);
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            //头像
            currentAccountPicture: GestureDetector(
              //圆形头像
              child: ClipOval(
                child: Image.network("https://avatars3.githubusercontent.com/u/19725223?s=400&u=f399a2d73fd0445be63ee6bc1ea4a408a62454f5&v=4")
              ),
              onTap: () {
                YToast.show(msg: "点击了头像");
              },
            ),
            //其他头像
            otherAccountsPictures: <Widget>[
              Icon(
                Icons.stars,
                color: Colors.white,
              ),
            ],
            //用户名
            accountName: Text(
              "这是名称",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            //用户邮箱
            accountEmail: Text("这是邮箱"),
            onDetailsPressed: () {
              YToast.show(msg: "详细信息");
            },
          ),

          ///功能列表
          ListTile(
            leading: new Icon(Icons.favorite_border),
            title: Text("收藏"),
            trailing: new Icon(Icons.chevron_right),
            onTap: () {
              YToast.show(msg: "收藏");
            },
          ),
          ListTile(
            leading: new Icon(Icons.info_outline),
            title: Text("关于"),
            trailing: new Icon(Icons.chevron_right),
            onTap: () {
              YToast.show(msg: "关于");
            },
          ),
          ListTile(
            leading: new Icon(Icons.share),
            title: Text("分享"),
            trailing: new Icon(Icons.chevron_right),
            onTap: () {
              YToast.show(msg: "分享");
            },
          ),

          Divider(),

          ListTile(
            leading: new Icon(Icons.block),
            title: Text("退出"),
            trailing: new Icon(Icons.chevron_right),
            onTap: () {
              YToast.show(msg: "退出");
              //关闭drawer
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
