

import 'package:flutter/material.dart';
import 'package:hot_news/pages/Tabs.dart';
import 'package:hot_news/pages/tabs/TopSearch.dart';
import 'package:hot_news/pages/tabs/TopSearchH5.dart';
final Map routes = {
  "/":(context)=>TabsPage(),
  "/topSearch":(context,{arguments})=>TopSearchPage(arguments: arguments,),
  "/topSearchH5":(context,{arguments})=>TopSearchH5Page(arguments: arguments,),

};
// ignore: top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) => pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }else{
    return null;
  }
};
