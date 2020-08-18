import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/Routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: "/",
        //不显示debug图标
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.white
        ),
        onGenerateRoute: onGenerateRoute,
    );
  }
}
