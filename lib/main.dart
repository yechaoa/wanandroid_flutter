import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_flutter/pages/homePage.dart';
import 'package:wanandroid_flutter/pages/naviPage.dart';
import 'package:wanandroid_flutter/pages/projectPage.dart';
import 'package:wanandroid_flutter/pages/treePage.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/res/strings.dart';

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
        title: Text(YStrings.appName),
      ),
//      body: Center(
//        child: pages.elementAt(_selectedIndex),
//      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(YStrings.home)),
          BottomNavigationBarItem(icon: Icon(Icons.filter_list), title: Text(YStrings.tree)),
          BottomNavigationBarItem(icon: Icon(Icons.low_priority), title: Text(YStrings.navi)),
          BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text(YStrings.project)),
        ],
        currentIndex: _selectedIndex,//当前选中下标
        type: BottomNavigationBarType.fixed,//显示模式
        fixedColor: YColors.colorPrimary,//选中颜色
        onTap: _onItemTapped, //点击事件
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showToast,
        tooltip: '点击选中最后一个',
        child: Icon(Icons.add,color: Colors.white),
      ),
    );
  }

  void _onItemTapped(int index) {
    //bottomNavigationBar 和 PageView 关联
    _pageController.animateToPage(index,duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _pageChange(int index) {
    setState(() {
      _selectedIndex = index;
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
        fontSize: 16.0);
    print("---click---");
    _onItemTapped(3);
  }
}
