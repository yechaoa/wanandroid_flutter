import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  int _selectedIndex = 1;
  final _widgetOptions = [
    Text('首页', style: TextStyle(fontSize: 30)),
    Text('体系', style: TextStyle(fontSize: 30)),
    Text('导航', style: TextStyle(fontSize: 30)),
    Text('项目', style: TextStyle(fontSize: 30)),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        title: Text(YStrings.appName),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(YStrings.home)),
          BottomNavigationBarItem(icon: Icon(Icons.filter_list), title: Text(YStrings.tree)),
          BottomNavigationBarItem(icon: Icon(Icons.low_priority), title: Text(YStrings.navi)),
          BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text(YStrings.project)),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: YColors.colorPrimary,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showToast,
        tooltip: '点击选中最后一个',
        child: Icon(Icons.add),
      ),
    );
  }

  void _onItemTapped(int index) {
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
