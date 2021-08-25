import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
