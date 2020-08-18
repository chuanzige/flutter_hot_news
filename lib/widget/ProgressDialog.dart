import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final bool loading;
  final Widget child;

  ProgressDialog({Key key, @required this.loading, @required this.child})
      : assert(child != null),
        assert(loading != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    //如果正在加载，则显示加载添加加载中布局
    if (loading) {
      //增加一层黑色背景透明度为0.8
      widgetList.add(
        Opacity(
            opacity: 0.8,
            child: ModalBarrier(
              color: Colors.black87,
            )),
      );
      //环形进度条
      widgetList.add(Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Stack(
      children: widgetList,
    );
  }
}