import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/common_entity.dart';
import 'package:wanandroid_flutter/entity/tree_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/util/ToastUtil.dart';
import 'package:wanandroid_flutter/widget/my_taurus_footer.dart';
import 'package:wanandroid_flutter/widget/my_taurus_header.dart';

import 'loginPage.dart';

class TreeDetailPage extends StatefulWidget {
  final int panelIndex; //一级分类选中下标
  final int index; //二级分类选中下标

  TreeDetailPage({Key key, @required this.panelIndex, @required this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TreeDetailPageState();
  }
}

class _TreeDetailPageState extends State<TreeDetailPage>
    with TickerProviderStateMixin {
  TabController _controller; //tab控制器
  int _currentIndex = 0; //选中下标

  List<TreeData> _datas = List(); //一级分类集合
  List<TreeDatachild> _tabDatas = List(); //二级分类 即 tab集合
  List<ArticleDataData> articleDatas = List(); //内容集合

  String _title = "标题";

  int _page = 0;

  @override
  void initState() {
    super.initState();
    //初始化controller
    _controller = TabController(vsync: this, length: 0);
    getHttp();
  }

  Future getHttp() async {
    var response = await HttpUtil().get(Api.TREE);
    Map userMap = json.decode(response.toString());
    var treeEntity = TreeEntity.fromJson(userMap);

    setState(() {
      _datas = treeEntity.data;
      _tabDatas = _datas[widget.panelIndex].children;
      _controller = TabController(vsync: this, length: _tabDatas.length);

      _currentIndex = widget.index;
      _title = _datas[widget.panelIndex].name;
    });

    //controller添加监听
    _controller.addListener(() => _onTabChanged());
    //选中指定下标
    _controller.animateTo(_currentIndex);

    getDetail();
  }

  /// tab改变监听
  /// 滑动切换_controller.indexIsChanging一直返回false，所以这种判断方式不适用了
  /// 修改如下
  _onTabChanged() {
    if (_controller.index.toDouble() == _controller.animation.value) {
      //赋值 并更新数据
      this.setState(() {
        _currentIndex = _controller.index;
      });
      getDetail();
    }
  }

  /// 根据tab下标获取数据
  Future getDetail() async {
    //加载重置
    this.setState(() {
      _page = 0;
    });
    var data = {"cid": _tabDatas[_currentIndex].id};
    var response =
        await HttpUtil().get(Api.ARTICLE_LIST + "$_page/json", data: data);
    Map articleMap = json.decode(response.toString());
    var articleEntity = ArticleEntity.fromJson(articleMap);

    if (0 == articleEntity.data.datas.length) {
      YToast.show(context: context, msg: "数据为空~");
    } else {
      setState(() {
        articleDatas = articleEntity.data.datas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        bottom: TabBar(
          controller: _controller,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 16),
          unselectedLabelColor: Colors.white60,
          unselectedLabelStyle: TextStyle(fontSize: 16),
          indicatorColor: Colors.white,
          isScrollable: true,
          //indicator与文字同宽
          indicatorSize: TabBarIndicatorSize.label,
          tabs: _tabDatas.map((TreeDatachild choice) {
            return Tab(
              text: choice.name,
            );
          }).toList(),
          onTap: (int i) {
            print(i);
          },
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: _tabDatas.map((TreeDatachild choice) {
          return EasyRefresh.custom(
            header: TaurusHeader(),
            footer: TaurusFooter(),
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  _page = 0;
                });
                getDetail();
              });
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 1), () async {
                setState(() {
                  _page++;
                });
                getMoreData();
              });
            },
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return getRow(index);
                  },
                  childCount: articleDatas.length,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: IconButton(
            icon: articleDatas[i].collect
                ? Icon(
                    Icons.favorite,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(Icons.favorite_border),
            tooltip: '收藏',
            onPressed: () {
              if (articleDatas[i].collect) {
                cancelCollect(articleDatas[i].id);
              } else {
                addCollect(articleDatas[i].id);
              }
            },
          ),
          title: Text(
            articleDatas[i].title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular((20.0)), // 圆角度
                  ),
                  child: Text(
                    articleDatas[i].superChapterName,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(articleDatas[i].author),
                ),
              ],
            ),
          ),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetail(
                title: articleDatas[i].title, url: articleDatas[i].link),
          ),
        );
      },
    );
  }

  Future addCollect(int id) async {
    var collectResponse = await HttpUtil().post(Api.COLLECT + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      YToast.show(context: context, msg: "收藏成功");
      getHttp();
    }
  }

  Future cancelCollect(int id) async {
    var collectResponse =
        await HttpUtil().post(Api.UN_COLLECT_ORIGIN_ID + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      YToast.show(context: context, msg: "取消成功");
      getHttp();
    }
  }

  Future getMoreData() async {
    var data = {"cid": _tabDatas[_currentIndex].id};
    var response =
        await HttpUtil().get(Api.ARTICLE_LIST + "$_page/json", data: data);
    Map articleMap = json.decode(response.toString());
    var articleEntity = ArticleEntity.fromJson(articleMap);
    setState(() {
      articleDatas.addAll(articleEntity.data.datas);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
