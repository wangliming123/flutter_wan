import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/util/Extension.dart';

class SimpleTextStyle extends TextStyle {
  SimpleTextStyle({
    double fontSize = 16,
    Color? color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    double fontHeightScale = 1.1
  }) :super(
      fontSize: ScreenUtil().setSp(fontSize),
      color: color,
      fontWeight: fontWeight,
      height: ScreenUtil().setHeight(fontHeightScale),
      decoration: TextDecoration.none);
}

class ColorRes {
  static final e2e2e2 = "#e2e2e2".color;
  static final colorPrimary = "#1296db".color;
  static final textColorPrimary = "#333333".color;
  static final textColorSecondary = "#99000000".color;
}

class StringRes {
  static final doubleClickExitStr = "再次点击退出";
  static final noMoreData = "没有更多了";
}
