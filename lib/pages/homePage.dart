import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provide/provide.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/entity/article_entity.dart';
import 'package:wanandroid_flutter/entity/banner_entity.dart';
import 'package:wanandroid_flutter/http/httpUtil.dart';
import 'package:wanandroid_flutter/pages/articleDetail.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/util/favoriteProvide.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerData> bannerDatas = List();
  List<ArticleDataData> articleDatas = List();

  ScrollController _scrollController;
  SwiperController _swiperController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() {});
    _swiperController = SwiperController();

    getHttp();
  }

  void getHttp() async {
    try {
      //banner
      var bannerResponse = await HttpUtil().get(Api.BANNER);
      Map bannerMap = json.decode(bannerResponse.toString());
      var bannerEntity = BannerEntity.fromJson(bannerMap);

      //article
      var articleResponse = await HttpUtil().get(Api.ARTICLE_LIST);
      Map articleMap = json.decode(articleResponse.toString());
      var articleEntity = ArticleEntity.fromJson(articleMap);

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
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            //1.8是banner宽高比，0.8是viewportFraction的值
            height: MediaQuery.of(context).size.width / 1.8 * 0.8,
            child: Swiper(
              itemCount: bannerDatas.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
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
              control: SwiperControl(),
              controller: _swiperController,
              //默认指示器
              pagination: SwiperPagination(
                // SwiperPagination.fraction 数字1/5，默认点
                builder: DotSwiperPaginationBuilder(size: 6, activeSize: 9),
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
            child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: articleDatas.length,
                itemBuilder: (BuildContext context, int position) {
                  if (position.isOdd) Divider();
                  return getRow(position);
                }),
          )
        ],
      ),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
            leading: Provide<FavoriteProvide>(
              builder: (context, child, favorite) {
                return IconButton(
                  icon: Provide.value<FavoriteProvide>(context).value
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  tooltip: '收藏',
                  onPressed: () {
                    Provide.value<FavoriteProvide>(context).changeFavorite(
                        !Provide.value<FavoriteProvide>(context).value);
                  },
                );
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
                      border:
                          Border.all(color: YColors.colorPrimary, width: 1.0),
                      borderRadius: BorderRadius.circular((20.0)), // 圆角度
                    ),
                    child: Text(articleDatas[i].superChapterName,
                        style: TextStyle(color: YColors.colorAccent)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(articleDatas[i].author),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right),
          )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticleDetail(
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
