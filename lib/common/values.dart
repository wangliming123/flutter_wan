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
}
