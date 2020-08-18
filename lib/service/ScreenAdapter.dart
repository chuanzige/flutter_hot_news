import 'package:flutter_screenutil/flutter_screenutil.dart';

//自己封装的屏幕适配器方法
class ScreenAdapter{

  //初始化
  static init(context){
    ScreenUtil.init(context,width: 750,height: 1334);
  }
  //设置高度
  static height(double value){
    return ScreenUtil().setHeight(value);
  }
  //设置宽度
  static width(double value){
    return ScreenUtil().setWidth(value);
  }
  //获取当前设备高度
  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }
  //获取当前设备宽度
  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }

  //设置字的大小
  static size(double value){
    return ScreenUtil().setSp(value);
  }
}

