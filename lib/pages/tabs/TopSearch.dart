import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hot_news/service/ScreenAdapter.dart';
import 'package:hot_news/widget/ProgressDialog.dart';
import 'package:luhenchang_plugin/time/data_time_utils/data_time.dart';


class TopSearchPage extends StatefulWidget {
  final Map arguments;
  TopSearchPage({Key key, this.arguments}) : super(key: key);

  @override
  _TopSearchPageState createState() {
    return _TopSearchPageState();
  }
}

class _TopSearchPageState extends State<TopSearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    if(widget.arguments!=null&&widget.arguments['keyWorld']!=null){
      keyWorld = widget.arguments['keyWorld'];
      flag = false;
      defaultButton = 4;
    }
    _getWeiBoHotNewsList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int defaultButton = 0;
  List newsList = [];
  List searchList = [];
  //默认不是搜索api
  bool flag = true;
  //默认type
  String type = "realTimeHotSearchList";
  String keyWorld;

  _getWeiBoHotNewsList() async {
    //热搜列表的api
    String url = "https://www.enlightent.cn/research/top/getWeiboRank.do?type=$type";
    //搜索热搜列表的api
    if(widget.arguments!=null&&widget.arguments['keyWorld']!=null){
      if(defaultButton==4){
        url = "https://www.enlightent.cn/research/top/getWeiboRankSearch.do?keyword=$keyWorld";
      }else{
        url = "https://www.enlightent.cn/research/top/getWeiboRankSearch.do?keyword=$keyWorld&type=$type";
      }
    }
    var response = await Dio().post(url);
    if (response.statusCode != 200) {
      Fluttertoast.showToast(
          msg: "加载失败~",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER);
    } else {
      setState(() {
       if(flag){
         newsList = response.data;
       }else{
         searchList = response.data['rows'];
       }
      });
    }
  }

  //时间转换 将秒转换为小时分钟
  String _durationTransform(int seconds) {
    var d = Duration(seconds:seconds);
    List<String> parts = d.toString().split(':');
    return '${parts[0]}小时${parts[1]}分';
  }

  //时间戳转日期格式
  String _dateFormatToString(int time){
    print(time);
    return DateUtils.instance.getFormartDate(time,format: "yyyy/MM/dd HH:mm");
  }

  //时间戳转日期格式
  String _dateFormatToString2(var time){
    print(time.runtimeType);
    if(time.runtimeType==double){
      return _dateFormatToString(time.toInt());
    }else if(time.runtimeType==String){
      print(time);
      print(time.runtimeType);
      return _dateFormatToString(int.parse(time));
    }
  }



  //下拉刷新
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _getWeiBoHotNewsList();
    Fluttertoast.showToast(
        msg: "刷新成功~",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER);
  }

  _topNewsPage(){
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            if(newsList[index]['url']!=null){
              Navigator.pushNamed(context, "/topSearchH5",arguments: {"url":newsList[index]['url']});
            }else{
              Fluttertoast.showToast(
                  msg: "没有对应的链接~",
                  toastLength: Toast.LENGTH_SHORT,
                  textColor: Colors.white,
                  gravity: ToastGravity.CENTER);
            }
          },
          child:Container(
            decoration: BoxDecoration(border: Border(
              top: BorderSide(
                color: Colors.black12,
              )
            )),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: newsList[index]['ranking']
                          .toString()
                          .replaceAll(".0", "")
                          .padLeft(2, "0"),
                      style: TextStyle(
                          fontSize: 28,
                          color: Color.fromRGBO(243, 186, 21, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: "PingFangSC-Semibold",
                          fontStyle: FontStyle.italic),
                      children: [
                        TextSpan(
                          text: "   ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(69, 69, 69, 1),
                              fontFamily: "PingFangSC-Semibold",
                              fontStyle: FontStyle.normal),
                        ),
                        TextSpan(
                          text: newsList[index]['keywords'],
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(69, 69, 69, 1),
                              fontFamily: "PingFangSC-Semibold",
                              fontStyle: FontStyle.normal),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("前72小时累计在榜:${_durationTransform(newsList[index]['duration'].toInt())}", style: TextStyle(fontSize: 10),),
                    Text(
                        "榜单历史最高排名:${newsList[index]['topRanking'].toInt().toString()}",
                        style: TextStyle(fontSize: 10)),
                    Text(
                        "搜索量: ${newsList[index]['searchNums'].toInt().toString()}",
                        style: TextStyle(fontSize: 10)),
                  ],
                )
              ],
            ),
          ),
        );
      },
      itemCount: newsList.length,
    );
  }

  _returnStrType(String type){
    switch(type) {
      case "realTimeHotSearchList": {
        return "微博";
      }
      break;
      case "douyin": {
        return "抖音";
      }
      break;
      case "toutiao": {
        return "头条";
      }
      break;
      default: {
        return "微博上升榜";
      }
      break;
    }
  }

  _topSearchNewsPage(){
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, "/topSearchH5",arguments: {"url":searchList[index]['url']});
          },
          child:Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      searchList[index]['keywords'],overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "PingFangSC-Semibold", fontStyle: FontStyle.italic),
                    ),
                    Text(_returnStrType(searchList[index]['type']),
                      style: TextStyle(fontSize: 20, color: Color.fromRGBO(243,186,21, 1), fontWeight: FontWeight.bold, fontFamily: "PingFangSC-Semibold", fontStyle: FontStyle.italic),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
               Text("最近一次上榜时间:${searchList.length>0?_dateFormatToString2(searchList[index]['updateTime']):14400000}", style: TextStyle(fontSize: 10),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("前72小时累计在榜:${_durationTransform(searchList[index]['duration'].toInt())}", style: TextStyle(fontSize: 10),),
                    Text(
                        "热搜历史最高排名:${searchList[index]['topRanking'].toInt().toString()}",
                        style: TextStyle(fontSize: 10)),
                    Text(
                        "搜索量: ${searchList[index]['searchNums']!=null?searchList[index]['searchNums'].toInt().toString():"无数据"}",
                        style: TextStyle(fontSize: 10)),
                  ],
                )
              ],
            ),
          ),
        );
      },
      itemCount: searchList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: flag?null:AppBar(),
      body: Container(
          child: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            Container(
              height: ScreenAdapter.height(250),
              child: FractionallySizedBox(
                alignment: Alignment.center,
                widthFactor: 1,
                heightFactor: 1,
                child: Image.network(
                  "https://www.enlightent.cn/research/resources/img/banner_two.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Row(
                    children: [
                      flag?Text(""):GestureDetector(
                          onTap: () {
                            defaultButton = 4;
                            _getWeiBoHotNewsList();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                color: defaultButton == 4 ? Color.fromRGBO(243, 186, 21, 1) : null,
                                border: Border.all(color: Color.fromRGBO(243, 186, 21, 1))),
                            child: Text("全平台", style: TextStyle(color: Colors.black, fontSize: 15),),
                          )),
                      GestureDetector(
                          onTap: () {
                            defaultButton = 0;
                            type = "realTimeHotSearchList";
                            _getWeiBoHotNewsList();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: defaultButton == 0 ? Color.fromRGBO(243, 186, 21, 1) : null, border: Border.all(color: Color.fromRGBO(243, 186, 21, 1))),
                            child: Text("微博", style: TextStyle(color: Colors.black, fontSize: 15),),
                          )),
                      GestureDetector(
                          onTap: () {
                            defaultButton = 1;
                            type = "realTimeHotSpots";
                            _getWeiBoHotNewsList();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                color: defaultButton == 1
                                    ? Color.fromRGBO(243, 186, 21, 1)
                                    : null,
                                border: Border.all(
                                    color: Color.fromRGBO(243, 186, 21, 1))),
                            child: Text(
                              "微博上升榜",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            defaultButton = 2;
                            type = "douyin";
                            _getWeiBoHotNewsList();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                color: defaultButton == 2
                                    ? Color.fromRGBO(243, 186, 21, 1)
                                    : null,
                                border: Border.all(
                                    color: Color.fromRGBO(243, 186, 21, 1))),
                            child: Text(
                              "抖音",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            defaultButton = 3;
                            type = "toutiao";
                            _getWeiBoHotNewsList();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                color: defaultButton == 3
                                    ? Color.fromRGBO(243, 186, 21, 1)
                                    : null,
                                border: Border.all(
                                    color: Color.fromRGBO(243, 186, 21, 1))),
                            child: Text(
                              "头条",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          )),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                        onTap: () {
                          _getWeiBoHotNewsList();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  color: Color.fromRGBO(243, 186, 21, 1))),
                          child: Text(
                            "点击刷新",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        )),
                  )
                ],
              )
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: flag?Text(
                "榜单时间: ${_dateFormatToString(newsList.length>0?newsList[0]['updateTime'].toInt():14400000)}",
                style: TextStyle(fontSize: 12, color: Colors.black38),
              ):Text(""),
            ),
            Expanded(
              flex: 1,
              child: flag?_topNewsPage():_topSearchNewsPage(),
            ),
          ],
        ),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
