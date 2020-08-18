import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:random_string/random_string.dart';


import 'package:fluttertoast/fluttertoast.dart';
import 'package:hot_news/service/ScreenAdapter.dart';

class HotWordsPage extends StatefulWidget {
  HotWordsPage({Key key}) : super(key: key);

  @override
  _HotWordsPageState createState() {
    return _HotWordsPageState();
  }
}

class _HotWordsPageState extends State<HotWordsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    //初始化加载热点词汇数据
    _getHotWords();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List _hotWordsList = [];

  //默认选中按钮
  int defaultButton = 0;

  _getHotWords({String dayType}) async {
    var response = await Dio().get(
        "https://www.enlightent.cn/research/top/getHotSearchWordcloud.do",
        queryParameters: {"dayType": dayType != null ? dayType : "now"});
    if (response.statusCode != 200) {
      Fluttertoast.showToast(
          msg: "加载失败~",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER);
    } else {
      setState(() {
        _hotWordsList = response.data;
      });
    }
  }

  _hotWordsPage() {
    return Wrap(
        children: _hotWordsList.map((data) {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/topSearch", arguments: {"keyWorld": "${data['keyword']}"});
        },
        child: Container(
            padding: EdgeInsets.all(5),
            child: Transform.rotate(
             angle: randomBetween(0,0).toDouble(),
          child: Text(
                "${data['keyword']}",
                style: TextStyle(color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0), fontSize: randomBetween(20,50).toDouble(), fontWeight: FontWeight.w800),
              ),
            )),
      );
    }).toList());
  }

  //下拉刷新
  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    _getHotWords();
    Fluttertoast.showToast(
        msg: "刷新成功~",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
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
                      "https://www.enlightent.cn/research/resources/img/banner_one.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            defaultButton = 0;
                            _getHotWords(dayType: "now");
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                color: defaultButton == 0
                                    ? Color.fromRGBO(243, 186, 21, 1)
                                    : null,
                                border: Border.all(
                                    color: Color.fromRGBO(243, 186, 21, 1))),
                            child: Text(
                              "实时热点",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            defaultButton = 1;
                            _getHotWords(dayType: "today");
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
                              "今日热点",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            defaultButton = 2;
                            _getHotWords(dayType: "yesterday");
                          },
                          child: Container(
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
                              "昨日热点",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          )),
                    ],
                  ),
                ),
                Divider(color: Colors.black12,),
                Expanded(
                    child: ListView(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                            ),
                            child: _hotWordsList.length > 0 ? _hotWordsPage() : Center(child: Text("还是空空的~"),)),
                      ],
                    )
                ),
              ],
            ),
          )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
