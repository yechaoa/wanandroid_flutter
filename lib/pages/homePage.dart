import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/banner_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/res/colors.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerData> bannerDatas = new List();
  List<ArticleDataData> articleDatas = new List();

  ScrollController _scrollController;
  SwiperController _swiperController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() {});
     _swiperController = new SwiperController();

    getHttp();
  }

  void getHttp() async {
    try {
      //banner
      var bannerResponse = await HttpUtil().get(Api.BANNER);
      Map bannerMap = json.decode(bannerResponse.toString());
      var bannerEntity = new BannerEntity.fromJson(bannerMap);

      //article
      var articleResponse = await HttpUtil().get(Api.ARTICLE_LIST);
      Map articleMap = json.decode(articleResponse.toString());
      var articleEntity = new ArticleEntity.fromJson(articleMap);

      setState(() {
        bannerDatas = bannerEntity.data;
        articleDatas = articleEntity.data.datas;
      });

      _swiperController.startAutoplay();

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            //1.8是banner宽高比，0.8是viewportFraction的值
            height: MediaQuery.of(context).size.width / 1.8 * 0.8,
            child: Swiper(
              itemCount: bannerDatas.length,
              itemBuilder: (BuildContext context, int index) {
                return new Image.network(
                  bannerDatas[index].imagePath,
                  fit: BoxFit.fill,
                );
              },
              loop: false,
              autoplay: false,
              autoplayDelay: 3000,
              //触发时是否停止播放
              autoplayDisableOnInteraction: true,
              duration: 600,
              //默认分页按钮
              control: new SwiperControl(),
              controller: _swiperController,
              //默认指示器
              pagination: new SwiperPagination(
                // SwiperPagination.fraction 数字1/5，默认点
                builder:
                    new DotSwiperPaginationBuilder(size: 6, activeSize: 9),
              ),

              //视图宽度，即显示的item的宽度屏占比
              viewportFraction: 0.8,
              //两侧item的缩放比
              scale: 0.9,

              onTap: (int index) {
                //点击事件，返回下标
                print("index-----" + index.toString());
              },
            ),
          ),
          Flexible(
            child: new ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: articleDatas.length,
                itemBuilder: (BuildContext context, int position) {
                  if (position.isOdd) return new Divider();
                  return getRow(position);
                }),
          )
        ],
      ),
    );
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Container(
          padding: new EdgeInsets.all(15.0),
          child: new ListTile(
            leading: new Icon(Icons.android),
            title: new Text(articleDatas[i].title,maxLines: 2,overflow: TextOverflow.ellipsis,),
            subtitle: new Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  decoration: new BoxDecoration(
                    border:
                        new Border.all(color: YColors.colorPrimary, width: 1.0),
                    borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                  ),
                  child: new Text(articleDatas[i].superChapterName,
                      style: TextStyle(color: YColors.colorAccent)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: new Text(articleDatas[i].author),
                ),
              ],
            ),
            trailing: new Icon(Icons.chevron_right),
          )),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new ArticleDetail(
                  title: articleDatas[i].title, url: articleDatas[i].link)),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    super.dispose();
  }
}
