import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';

class PageStateView extends StatelessWidget {
  static const int showContent = 0;
  static const int showLoading = 1;
  static const int showEmpty = 2;
  static const int showError = 3;

  final Widget contentView;
  int state;
  final Function? onEmptyClick;
  final Function? onErrorClick;

  PageStateView(
      {required this.contentView,
      this.state = showLoading,
      this.onEmptyClick,
      this.onErrorClick});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Image(
            width: 30.w,
            height: 30.w,
            image: AssetImage("images/loading_icon.gif"),
          ),
        ).visible(state == showLoading),
        Container(
          alignment: Alignment.center,
          child: UiUtils.text(
            "暂无数据 o(╥﹏╥)o \n 点击重新加载",
            20.sp,
            ColorRes.textColorSecondary,
            textAlign: TextAlign.center,
          ),
        ).onTap(() => {onEmptyClick?.call()}).visible(state == showEmpty),
        Container(
          alignment: Alignment.center,
          child: UiUtils.text(
            "加载失败 o(╥﹏╥)o \n 点击重新加载",
            20.sp,
            ColorRes.textColorSecondary,
            textAlign: TextAlign.center,
          ),
        ).onTap(() => {onErrorClick?.call()}).visible(state == showError),
        Container(
          child: contentView,
        ).visible(state == showContent),
      ],
    );
  }
}
