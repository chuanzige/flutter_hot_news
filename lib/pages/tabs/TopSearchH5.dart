import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class TopSearchH5Page extends StatefulWidget {
  final Map arguments;

  TopSearchH5Page({Key key, this.arguments}) : super(key: key);

  @override
  _TopSearchH5PageState createState() {
    return _TopSearchH5PageState();
  }
}

class _TopSearchH5PageState extends State<TopSearchH5Page> {
  @override
  void initState() {
    super.initState();
    print(widget.arguments);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _launchURL() async {
    const url = 'sinaweibo://search';
      await launch(url);
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("热搜详情"),),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: InAppWebView(
                    initialUrl: widget.arguments['url'],
                    initialHeaders: {},
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: false,
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
