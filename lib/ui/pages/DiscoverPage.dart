import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/Const.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/http/ApiException.dart';
import 'package:flutter_wan/http/ApiService.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UiUtils.lineTabButton(
          "广场",
          16.sp,
          textColor: ColorRes.textColorPrimary,
          height: 50.w,
          leftIcon: Icon(IconData(59112, fontFamily: "iconfont1"), size: 25.w),
          rightIcon: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.pushNamed(context, RouteConst.square);
          },
        ).padding(top: 5.w, bottom: 5.w),
        UiUtils.lineTabButton(
          "知识体系",
          16.sp,
          textColor: ColorRes.textColorPrimary,
          height: 50.w,
          leftIcon: Icon(IconData(59046, fontFamily: "iconfont1"), size: 25.w),
          rightIcon: Icon(Icons.keyboard_arrow_right),
          onTap: () {Navigator.pushNamed(context, RouteConst.knowledgeTree);},
        ).padding(top: 5.w, bottom: 5.w),
        UiUtils.lineTabButton(
          "导航",
          16.sp,
          textColor: ColorRes.textColorPrimary,
          height: 50.w,
          leftIcon: Icon(Icons.navigation_outlined, size: 25.w),
          rightIcon: Icon(Icons.keyboard_arrow_right),
          onTap: () {Navigator.pushNamed(context, RouteConst.navigation);},
        ).padding(top: 5.w, bottom: 5.w),
        UiUtils.lineTabButton(
          "开源项目",
          16.sp,
          textColor: ColorRes.textColorPrimary,
          height: 50.w,
          leftIcon: Icon(IconData(58889, fontFamily: "iconfont1"), size: 25.w),
          rightIcon: Icon(Icons.keyboard_arrow_right),
          onTap: () => _goKnowledgeInfo(context, 293),
        ).padding(top: 5.w, bottom: 5.w),
        UiUtils.lineTabButton(
          "公众号",
          16.sp,
          textColor: ColorRes.textColorPrimary,
          height: 50.w,
          leftIcon: Icon(IconData(58962, fontFamily: "iconfont1"), size: 25.w),
          rightIcon: Icon(Icons.keyboard_arrow_right),
          onTap: () => _goKnowledgeInfo(context, 407),
        ).padding(top: 5.w, bottom: 5.w),
        UiUtils.lineTabButton(
          "jetpack",
          16.sp,
          textColor: ColorRes.textColorPrimary,
          height: 50.w,
          leftIcon: Icon(IconData(58892, fontFamily: "iconfont1"), size: 25.w),
          rightIcon: Icon(Icons.keyboard_arrow_right),
          onTap: () => _goKnowledgeInfo(context, 422),
        ).padding(top: 5.w, bottom: 5.w),
      ],
    );
  }

  _goKnowledgeInfo(BuildContext context, int id) async {
    var knowledge;
    try {
      var data = await ApiService.ins().getHttpAsync(context, "tree/json");
      if (data is List) {
        for (var element in data) {
          if (element["id"] == id) {
            knowledge = element;
            break;
          }
        }
      }
    } on ApiException catch(e) {
      e.msg?.toast();
      return;
    }
    Navigator.pushNamed(context, RouteConst.knowledgeInfo, arguments: {
      "knowledge": knowledge,
      "id": id,
    });
  }
}
