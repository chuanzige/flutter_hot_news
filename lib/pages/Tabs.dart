import 'package:flutter/material.dart';
import 'package:hot_news/pages/tabs/HotWords.dart';
import 'package:hot_news/pages/tabs/ReminderNews.dart';
import 'package:hot_news/pages/tabs/TopSearch.dart';

class TabsPage extends StatefulWidget {
  TabsPage({Key key}) : super(key: key);

  @override
  _TabsPageState createState() {
    return _TabsPageState();
  }
}

class _TabsPageState extends State<TabsPage> {

  PageController _controller;
  //默认跳转页
  int _indexPageCount = 0;
  //页面列表
  List<Widget> _pageList = [HotWordsPage(),TopSearchPage(),ReminderNewsPage(),];

  @override
  void initState() {
    super.initState();
    _controller = new PageController(initialPage: _indexPageCount);
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _pageList,
        controller: _controller,
        physics: new NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(_indexPageCount!=0?Icons.face:Icons.tag_faces),title: Text("热点词汇")),
          BottomNavigationBarItem(icon: Icon(_indexPageCount!=1?Icons.search:Icons.youtube_searched_for),title: Text("热搜排行")),
          BottomNavigationBarItem(icon: Icon(_indexPageCount!=2?Icons.perm_identity:Icons.people_outline),title: Text("热搜报警")),
        ],
        currentIndex: _indexPageCount,
        fixedColor: Colors.black,
        onTap: (index){
          setState(() {
            _indexPageCount = index;
            _controller.jumpToPage(index);
          });
        },
      ),
    );
  }
}